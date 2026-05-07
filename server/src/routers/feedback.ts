import { submitFeedback, getFeedbackAnalytics } from "@/controllers/feedback";
import { authMiddleware } from "@/middleware/auth";
import express from "express";

export const feedbackRouter = express.Router();

feedbackRouter.post("/", authMiddleware, submitFeedback);
feedbackRouter.get("/analytics", authMiddleware, getFeedbackAnalytics);

export type FeedbackRouter = typeof feedbackRouter;
