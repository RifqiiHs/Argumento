import type { Request, Response } from 'express';
import User from '@/models/User';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import Posts from '@/models/Posts';
import crypto from 'crypto';
import { sendResetPasswordEmail, sendVerificationEmail } from '@/utils/mail';

const RegisterSchema = z.object({
  username: z.string().min(3),
  password: z.string().min(8),
  email: z.string().email(),
});

const LoginSchema = z.object({
  username: z.string(),
  password: z.string(),
});

export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { username, password, email } = RegisterSchema.parse(req.body);
    const hashedPassword = await bcrypt.hash(password, 10);

    const existingUser = await User.findOne({ $or: [{ username }, { email }] });
    if (existingUser) {
      res.status(400).json({
        success: false,
        message:
          existingUser.username === username
            ? 'Username already exists'
            : 'Email already exists',
      });
      return;
    }

    const verifyToken = crypto.randomBytes(5).toString('hex');
    const expiryTime = new Date(Date.now() + 1000 * 60 * 60); // 1 hour

    const user = new User({
      username,
      password: hashedPassword,
      email,
      verifyToken,
      verifyTokenGeneratedAt: new Date(),
      verifyTokenExpiry: expiryTime,
    });

    await user.save();

    // Send verification email - non-blocking, won't fail registration if email not configured
    if (process.env.GMAIL_USER && process.env.GMAIL_APP_PASS) {
      sendVerificationEmail(email, verifyToken).catch((err: Error) =>
        console.warn('⚠️  Verification email failed (check GMAIL config):', err.message)
      );
    } else {
      console.warn('⚠️  GMAIL not configured - skipping verification email');
    }

    const token = jwt.sign(
      { userId: user._id.toString() },
      process.env.JWT_SECRET || 'default_secret',
      { expiresIn: '30d' }
    );

    res.status(200).json({ success: true, message: 'Success', token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { username, password } = LoginSchema.parse(req.body);
    const user = await User.findOne({ username });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      res.status(400).json({ success: false, message: 'Invalid username or password' });
      return;
    }

    const token = jwt.sign(
      { userId: user._id.toString() },
      process.env.JWT_SECRET || 'default_secret',
      { expiresIn: '30d' }
    );

    res.status(200).json({ success: true, message: 'Success', token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const getMe = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.users;
    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const user = await User.findById(userId);
    if (!user) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const userObj = user.toObject();
    const { password, ...safeUser } = userObj as any;

    safeUser.postsHistory = await Promise.all(
      safeUser.postsHistory.map(async (item: any) => {
        const post = await Posts.findById(item.post_id);
        return { post_id: item.post_id, is_correct: item.is_correct, post };
      })
    );

    res.status(200).json({ success: true, user: safeUser });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const sendVerifyEmail = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      res.status(404).json({ success: false, message: 'Not Found' });
      return;
    }
    if (user.isVerified) {
      res.status(400).json({ success: false, message: 'User is already verified.' });
      return;
    }

    const cooldown = 60;
    const lastGenerated = user.verifyTokenGeneratedAt
      ? new Date(user.verifyTokenGeneratedAt).getTime()
      : 0;
    const now = Date.now();

    if (now - lastGenerated < cooldown * 1000) {
      const waitTime = Math.ceil((cooldown * 1000 - (now - lastGenerated)) / 1000);
      res.status(429).json({
        success: false,
        message: `Please wait ${waitTime}s before requesting another email.`,
      });
      return;
    }

    const verifyToken = crypto.randomBytes(5).toString('hex');
    const expiryTime = new Date(Date.now() + 1000 * 60 * 60);

    user.verifyToken = verifyToken;
    user.verifyTokenGeneratedAt = new Date();
    user.verifyTokenExpiry = expiryTime;

    await user.save();

    if (process.env.GMAIL_USER && process.env.GMAIL_APP_PASS) {
      await sendVerificationEmail(user.email, verifyToken);
    } else {
      console.warn('⚠️  GMAIL not configured - verification token:', verifyToken);
    }

    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const verifyEmail = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const user = await User.findOne({ verifyToken: id });

    if (!user) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const currTime = new Date();
    if (user.verifyTokenExpiry && currTime > user.verifyTokenExpiry) {
      res.status(401).json({ success: false, message: 'Token expired' });
      return;
    }

    user.verifyToken = null;
    user.verifyTokenExpiry = null;
    user.verifyTokenGeneratedAt = null;
    user.isVerified = true;

    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const generateResetToken = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      // Don't reveal if email exists
      res.status(200).json({ success: true, message: 'Success' });
      return;
    }

    const resetToken = crypto.randomBytes(6).toString('hex');
    const expiryTime = new Date(Date.now() + 1000 * 60 * 60);

    user.resetToken = resetToken;
    user.resetTokenGeneratedAt = new Date();
    user.resetTokenExpiry = expiryTime;

    await user.save();

    if (process.env.GMAIL_USER && process.env.GMAIL_APP_PASS) {
      await sendResetPasswordEmail(email, resetToken);
    } else {
      console.warn('⚠️  GMAIL not configured - reset token:', resetToken);
    }

    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const resetPassword = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { newPassword } = req.body;
    const user = await User.findOne({ resetToken: id });

    if (!user) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const currTime = new Date();
    if (user.resetTokenExpiry && currTime > user.resetTokenExpiry) {
      res.status(401).json({ success: false, message: 'Token expired' });
      return;
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    user.resetToken = null;
    user.resetTokenExpiry = null;
    user.resetTokenGeneratedAt = null;

    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const deleteAccount = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.users;
    await User.findByIdAndDelete(userId);
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};
