import type { Request, Response } from 'express';
import User from '@/models/User';
import Posts from '@/models/Posts';
import Feedback from '@/models/Feedback';
import { shop } from '@/utils/shop';

// ============ LEADERBOARD ============
export const getLeaderboard = async (req: Request, res: Response): Promise<void> => {
  try {
    const { type = 'totalExp' } = req.params;
    const validFields = ['totalExp', 'bestStreak', 'currentStreak', 'postsProcessed', 'postsCorrect'];
    const sortField = validFields.includes(type) ? type : 'totalExp';

    const data = await User.find({}, '-password').sort({ [sortField]: -1 }).limit(100);
    res.status(200).json({ success: true, message: 'Success', data });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

// ============ SHOP ============
export const getShops = async (_req: Request, res: Response): Promise<void> => {
  try {
    res.status(200).json({ success: true, shop });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const buyShopItem = async (req: Request, res: Response): Promise<void> => {
  try {
    const { type, itemId }: { type: string; itemId: string } = req.body;
    const userId = req.users;

    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    const items = shop[type as keyof typeof shop] as any[];
    const item = items?.find((it) => it.id === itemId);
    if (!item) {
      res.status(404).json({ success: false, message: 'Item not found' });
      return;
    }

    if (user.totalCoins < item.price) {
      res.status(400).json({ success: false, message: 'Insufficient coins' });
      return;
    }

    user.totalCoins -= item.price;
    if (type === 'themes') {
      user.inventory.themes.push(itemId);
    } else {
      const existingConsumable = user.inventory.consumables.find(
        (it) => it.itemId === itemId
      );
      if (existingConsumable) {
        existingConsumable.amount++;
      } else {
        user.inventory.consumables.push({ itemId, amount: 1 });
      }
    }

    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

// ============ USER ============
export const getUserById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;
    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }
    res.status(200).json({ success: true, user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const equipTheme = async (req: Request, res: Response): Promise<void> => {
  try {
    const { itemId } = req.body;
    const userId = req.users;

    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    const item = shop.themes.find((it) => it.id === itemId);
    if (!item) {
      res.status(404).json({ success: false, message: 'Theme not found' });
      return;
    }

    user.activeTheme = itemId;
    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const refreshStreak = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.users;
    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    const lastPlayed = new Date(user.lastPlayedDate || 0).getTime();
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    const nowTime = now.getTime();
    const msPerDay = 1000 * 60 * 60 * 24;
    const daysDiff = Math.floor((nowTime - lastPlayed) / msPerDay);

    if (daysDiff > 1) {
      user.currentStreak = 0;
    }
    if (user.currentStreak > user.bestStreak) {
      user.bestStreak = user.currentStreak;
    }

    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

// ============ POSTS ============
export const getPost = async (req: Request, res: Response): Promise<void> => {
  try {
    const { postId } = req.params;
    const post = await Posts.findById(postId);
    if (!post) {
      res.status(404).json({ success: false, message: 'Post not found' });
      return;
    }
    res.status(200).json({ success: true, post });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

// ============ FEEDBACK ============
export const submitFeedback = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.users;
    const {
      description, expectation, favoritePart, frustrated,
      clarity, playAgainTomorrow, improvements, learnedSomething,
      changesSocialMedia, anythingElse,
    } = req.body;

    const feedback = new Feedback({
      userId,
      description, expectation, favoritePart, frustrated,
      clarity, playAgainTomorrow, improvements, learnedSomething,
      changesSocialMedia, anythingElse,
    });

    await feedback.save();
    res.status(201).json({ success: true, message: 'Thank you for your feedback!', feedback });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const getFeedbackAnalytics = async (_req: Request, res: Response): Promise<void> => {
  try {
    const allFeedback = await Feedback.find();
    const analytics = {
      totalResponses: allFeedback.length,
      avgRetention:
        allFeedback.length > 0
          ? (allFeedback.reduce((sum, f) => sum + f.playAgainTomorrow, 0) / allFeedback.length).toFixed(2)
          : '0',
      avgClarity:
        allFeedback.length > 0
          ? (allFeedback.reduce((sum, f) => sum + f.clarity, 0) / allFeedback.length).toFixed(2)
          : '0',
      expectations: {
        better: allFeedback.filter((f) => f.expectation === 'better').length,
        same: allFeedback.filter((f) => f.expectation === 'same').length,
        worse: allFeedback.filter((f) => f.expectation === 'worse').length,
      },
      learnedDistribution: {
        yes_lot: allFeedback.filter((f) => f.learnedSomething === 'yes_lot').length,
        yes_little: allFeedback.filter((f) => f.learnedSomething === 'yes_little').length,
        not_really: allFeedback.filter((f) => f.learnedSomething === 'not_really').length,
        already_knew: allFeedback.filter((f) => f.learnedSomething === 'already_knew').length,
      },
      changeBehavior: {
        yes: allFeedback.filter((f) => f.changesSocialMedia === 'yes').length,
        maybe: allFeedback.filter((f) => f.changesSocialMedia === 'maybe').length,
        probably_not: allFeedback.filter((f) => f.changesSocialMedia === 'probably_not').length,
        no: allFeedback.filter((f) => f.changesSocialMedia === 'no').length,
      },
    };
    res.status(200).json({ success: true, analytics, allFeedback });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};
