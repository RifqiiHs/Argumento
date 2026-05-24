import express from 'express';
import { authMiddleware } from '@/middleware/auth';
import * as authCtrl from '@/controllers/auth';
import * as shiftsCtrl from '@/controllers/shifts';
import * as judgeCtrl from '@/controllers/judge';
import * as campaignCtrl from '@/controllers/campaign';
import * as miscCtrl from '@/controllers/misc';

export const appRouter = express.Router();

// Health check
appRouter.get('/', (_req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is healthy' });
});

// AUTH routes
appRouter.post('/auth/login', authCtrl.login);
appRouter.post('/auth/register', authCtrl.register);
appRouter.get('/auth', authMiddleware, authCtrl.getMe);
appRouter.post('/auth/verify', authCtrl.sendVerifyEmail);
appRouter.put('/auth/verify/:id', authCtrl.verifyEmail);
appRouter.post('/auth/reset', authCtrl.generateResetToken);
appRouter.put('/auth/reset/:id', authCtrl.resetPassword);
appRouter.delete('/auth', authMiddleware, authCtrl.deleteAccount);

// SHIFTS routes
appRouter.post('/shifts/generate', authMiddleware, shiftsCtrl.generateDailyShift);
appRouter.post('/shifts/practice', authMiddleware, shiftsCtrl.generatePracticeShifts);
appRouter.put('/shifts/complete', authMiddleware, shiftsCtrl.completeShift);

// JUDGE routes
appRouter.post('/judge', authMiddleware, judgeCtrl.judge);

// CAMPAIGN routes
appRouter.get('/campaign', authMiddleware, campaignCtrl.getCampaign);
appRouter.get('/campaign/:level/:id', campaignCtrl.getLevel);
appRouter.post('/campaign/complete/:level/:id', authMiddleware, campaignCtrl.completeCampaignLevel);

// LEADERBOARD routes
appRouter.get('/leaderboard/:type', miscCtrl.getLeaderboard);

// SHOP routes
appRouter.get('/shops', miscCtrl.getShops);
appRouter.put('/shops', authMiddleware, miscCtrl.buyShopItem);

// USER routes
appRouter.get('/users/:userId', miscCtrl.getUserById);
appRouter.put('/users/theme', authMiddleware, miscCtrl.equipTheme);
appRouter.put('/users/streak', authMiddleware, miscCtrl.refreshStreak);

// POSTS routes
appRouter.get('/posts/:postId', miscCtrl.getPost);

// FEEDBACK routes
appRouter.post('/feedback', authMiddleware, miscCtrl.submitFeedback);
appRouter.get('/feedback/analytics', authMiddleware, miscCtrl.getFeedbackAnalytics);
