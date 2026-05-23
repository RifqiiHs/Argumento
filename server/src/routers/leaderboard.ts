import { getLeaderboard } from "@/controllers/leaderboard";
import express from "express";

export const leaderboardRouter = express.Router();

leaderboardRouter.get("/:type", getLeaderboard);

export type LeaderboardRouter = typeof leaderboardRouter;
