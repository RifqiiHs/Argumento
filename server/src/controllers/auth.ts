import type { Request, Response } from "express";
import User from "@/db/models/User";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import z from "zod";
import Posts from "@/db/models/Posts";
import crypto from "crypto";
import { sendResetPasswordEmail, sendVerificationEmail } from "@/utils/mail";
declare global {
    namespace Express {
        interface Request {
            userId?: string;
        }
    }
}

const RegisterSchema = z.object({
    username: z.string().min(3),
    password: z.string().min(8),
    email: z.email(),
});

const LoginSchema = z.object({
    username: z.string(),
    password: z.string(),
});
export const register = async (req: Request, res: Response) => {
    try {
        const { username, password, email } = RegisterSchema.parse(req.body);

        const hashedPassword = await bcrypt.hash(password, 10);

        const existingUser = await User.findOne({
            $or: [{ username }, { email }],
        });

        if (existingUser) {
            return res.status(400).json({
                success: false,
                message:
                    existingUser.username === username
                        ? "Username already exists"
                        : "Email already exists",
            });
        }

        const verifyToken = crypto.randomBytes(5).toString("hex");
        const expiryTime = new Date(Date.now() + 1000 * 60 * 60); // 1 hour

        const user = new User({
            username: username,
            password: hashedPassword,
            email: email,
            verifyToken: verifyToken,
            verifyTokenGeneratedAt: new Date(),
            verifyTokenExpiry: expiryTime,
        });

        await sendVerificationEmail(email, verifyToken);

        await user.save();

        const token = jwt.sign(
            {
                userId: user._id,
            },
            process.env.JWT_SECRET || "default_secret",
            { expiresIn: "30d" }
        );

        res.status(200).json({ success: true, message: "Success", token });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const login = async (req: Request, res: Response) => {
    try {
        const { username, password } = LoginSchema.parse(req.body);

        const user = await User.findOne({
            username,
        });

        if (!user || !(await bcrypt.compare(password, user.password))) {
            return res.status(400).send({
                success: false,
                message: "Invalid username or password",
            });
        }

        const token = jwt.sign(
            {
                userId: user._id,
            },
            process.env.JWT_SECRET || "default_secret",
            { expiresIn: "30d" }
        );

        res.status(200).json({ success: true, message: "Success", token });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const getMe = async (req: Request, res: Response) => {
    try {
        const userId = req.users;

        if (!userId) {
            return res.status(401).send({
                success: false,
                message: "Unauthorized",
            });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(401).send({
                success: false,
                message: "Unauthorized",
            });
        }

        const userObj = user.toObject();
        const { password, ...safeUser } = userObj;

        safeUser.postsHistory = await Promise.all(
            safeUser.postsHistory.map(async (item) => {
                const post = await Posts.findById(item.post_id);
                return {
                    post_id: item.post_id,
                    is_correct: item.is_correct,
                    post,
                };
            })
        );

        res.status(200).json({
            success: true,
            user: safeUser,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const sendVerifyEmail = async (req: Request, res: Response) => {
    try {
        const { email } = req.body;

        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "Not Found",
            });
        }

        if (user.isVerified) {
            return res.status(400).json({
                success: false,
                message: "User is already verified.",
            });
        }

        const cooldown = 60;
        const lastGenerated = user.verifyTokenGeneratedAt
            ? new Date(user.verifyTokenGeneratedAt).getTime()
            : 0;
        const now = Date.now();

        if (now - lastGenerated < cooldown * 1000) {
            const waitTime = Math.ceil(
                (cooldown * 1000 - (now - lastGenerated)) / 1000
            );
            return res.status(429).json({
                success: false,
                message: `Please wait ${waitTime}s before requesting another email.`,
            });
        }

        const verifyToken = crypto.randomBytes(5).toString("hex");
        const expiryTime = new Date(Date.now() + 1000 * 60 * 60); // 1 hour

        user.verifyToken = verifyToken;
        user.verifyTokenGeneratedAt = new Date();
        user.verifyTokenExpiry = expiryTime;

        await user.save();
        await sendVerificationEmail(user.email, verifyToken);

        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const verifyEmail = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const user = await User.findOne({
            verifyToken: id,
        });

        if (!user) {
            return res
                .status(401)
                .send({ success: false, message: "Unauthorized" });
        }
        if (
            !user.verifyToken &&
            !user.verifyTokenExpiry &&
            !user.verifyTokenGeneratedAt
        ) {
            return res
                .status(401)
                .send({ success: false, message: "Unauthorized" });
        }

        const currTime = new Date();

        if (user.verifyTokenExpiry && currTime > user.verifyTokenExpiry) {
            return res
                .status(401)
                .send({ success: false, message: "Token expired" });
        }

        user.verifyToken = null;
        user.verifyTokenExpiry = null;
        user.verifyTokenGeneratedAt = null;
        user.isVerified = true;

        await user.save();
        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const generateResetToken = async (req: Request, res: Response) => {
    try {
        const { email } = req.body;

        const user = await User.findOne({ email });
        if (!user) {
            return res.status(200).send({
                success: true,
                message: "Success",
            });
        }

        const resetToken = crypto.randomBytes(6).toString("hex");
        const expiryTime = new Date(Date.now() + 1000 * 60 * 60); // 1 hour

        user.resetToken = resetToken;
        user.resetTokenGeneratedAt = new Date();
        user.resetTokenExpiry = expiryTime;

        await user.save();

        await sendResetPasswordEmail(email, resetToken);

        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const resetPassword = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { newPassword } = req.body;
        const user = await User.findOne({
            resetToken: id,
        });

        if (!user) {
            return res
                .status(401)
                .send({ success: false, message: "Unauthorized" });
        }
        if (
            !user.resetToken &&
            !user.resetTokenExpiry &&
            !user.resetTokenGeneratedAt
        ) {
            return res
                .status(401)
                .send({ success: false, message: "Unauthorized" });
        }

        const currTime = new Date();

        if (user.resetTokenExpiry && currTime > user.resetTokenExpiry) {
            return res
                .status(401)
                .send({ success: false, message: "Token expired" });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

        user.password = hashedPassword;
        user.resetToken = null;
        user.resetTokenExpiry = null;
        user.resetTokenGeneratedAt = null;

        await user.save();

        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const deleteAccount = async (req: Request, res: Response) => {
    try {
        const userId = req.users;

        await User.findByIdAndDelete(userId);

        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};
