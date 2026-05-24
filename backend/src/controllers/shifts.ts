import type { Request, Response } from 'express';
import Posts from '@/models/Posts';
import User, { type IUsers } from '@/models/User';
import { GoogleGenAI } from '@google/genai';
import dotenv from 'dotenv';
import { XP, CORRECT_COINS, INCORRECT_COINS } from '@/utils/game_config';

dotenv.config();

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_AI_API });

interface IPostLog {
  post_id: string;
  is_correct: boolean;
}

const CATEGORY_NAMES: Record<string, string> = {
  logical_fallacies: 'Logical Fallacies',
  cognitive_biases: 'Cognitive Biases',
  media_manipulation: 'Media Manipulation',
  ai_hallucinations: 'AI Hallucinations',
  safe: 'Safe Content',
};

const buildShiftPrompt = (postLength: number, types: Record<string, string[]>): string => `
ROLE: You are the 'Simulation Engine' for a cognitive defense game. Your goal is to generate social media posts that look identical to real-world content but contain hidden logical traps.

TASK: Generate exactly ${postLength} items in a JSON Array.

INPUT_TARGETS: ${JSON.stringify(types)}

GENERATION RULES:
DISTRIBUTION:
- 50% "Safe" (Valid Logic)
- 50% "Slop" (Fallacious Logic)

STYLE GUIDE (Apply to ALL posts):
- Tone: Twitter/X style, Reddit comments, or News Headlines.
- Format: Short, punchy, opinionated. Use 1-2 emojis occasionally.
- Content: distinct topics per post (Politics, Tech, Health, Pop Culture, Economics).
- CRITICAL: Do not make "Safe" posts boring. They should be strong opinions backed by valid reasoning, or neutral reporting.

INSTRUCTIONS FOR "SLOP":
1. Select a specific flaw from INPUT_TARGETS.
2. Construct a post that sounds convincing but relies entirely on that flaw.
3. Subtlety is key.

INSTRUCTIONS FOR "SAFE":
1. Write a post that makes a claim.
2. Ensure the claim is supported by a direct premise or is a verifiable neutral fact.
3. It must NOT contain any logical fallacies.

OUTPUT FORMAT - Return ONLY a valid JSON Array. No markdown, no pre-text.
Item Schema:
{
  "headline": "A short, catchy title or username",
  "content": "The text of the post (max 280 chars)",
  "type": "slop" | "safe",
  "reasons": ["The specific key of the fallacy used"] (Empty array if Safe),
  "category": "The parent category (e.g. 'logical_fallacies')" (Use 'safe' if Safe),
  "origin": "ai"
}
`;

const parseAIResponse = (text: string): any[] => {
  const cleaned = text
    ?.replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim();
  return JSON.parse(cleaned || '[]');
};

export const generateDailyShift = async (req: Request, res: Response): Promise<void> => {
  try {
    const { postLength, types } = req.body;
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

    const prompt = buildShiftPrompt(postLength, types);
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
    });

    const text = response?.candidates?.[0]?.content?.parts?.[0]?.text || '[]';
    const parsed = parseAIResponse(text);
    const savedPosts = await Posts.insertMany(parsed);

    res.status(200).json({ success: true, message: 'Success', posts: savedPosts });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const generatePracticeShifts = async (req: Request, res: Response): Promise<void> => {
  try {
    const { postLength, types } = req.body;
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

    const prompt = buildShiftPrompt(postLength, types);
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
    });

    const text = response?.candidates?.[0]?.content?.parts?.[0]?.text || '[]';
    const parsed = parseAIResponse(text);

    // Practice mode: do NOT save to DB (no stats tracked)
    res.status(200).json({ success: true, message: 'Success', posts: parsed });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const completeShift = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.users;
    const { history } = req.body;

    const user: IUsers | null = await User.findById(userId);
    if (!user) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const postCorrect = history.filter((item: IPostLog) => item.is_correct).length;
    const expEarned = postCorrect * XP;

    const sentData = await Promise.all(
      history.map(async (item: IPostLog) => {
        const post = await Posts.findById(item.post_id);
        if (!post) throw new Error(`Post not found: ${item.post_id}`);
        return { post_id: item.post_id, is_correct: item.is_correct, category: post.category };
      })
    );

    // Update stats per category
    sentData.forEach((item) => {
      if (!item.category) return;
      const existingStat = user.stats.find((s) => s.stat_id === item.category);
      if (existingStat) {
        existingStat.total++;
        if (item.is_correct) existingStat.correct++;
      } else {
        user.stats.push({
          stat_id: item.category,
          name: CATEGORY_NAMES[item.category] || item.category,
          total: 1,
          correct: item.is_correct ? 1 : 0,
        });
      }
    });

    // Streak logic
    const lastPlayed = new Date(user.lastPlayedDate || 0).getTime();
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    const nowTime = now.getTime();
    const msPerDay = 1000 * 60 * 60 * 24;
    const daysDiff = Math.floor((nowTime - lastPlayed) / msPerDay);

    if (!user.lastPlayedDate) {
      user.currentStreak = 1;
    } else {
      if (daysDiff === 1) {
        user.currentStreak += 1;
      } else if (daysDiff > 1) {
        user.currentStreak = 1;
      }
    }

    if (user.currentStreak > user.bestStreak) {
      user.bestStreak = user.currentStreak;
    }

    user.lastPlayedDate = new Date();
    user.totalExp += expEarned;
    user.postsProcessed += sentData.length;
    user.postsCorrect += postCorrect;
    user.totalCoins +=
      postCorrect * CORRECT_COINS + (sentData.length - postCorrect) * INCORRECT_COINS;
    user.postsHistory.push(...sentData);

    await user.save();
    res.status(200).json({ success: true, message: 'Success', data: user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};
