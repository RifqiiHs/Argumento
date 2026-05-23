import express, { type Request, type Response } from "express";
import { authRouter } from "./auth";
import { judgeRouter } from "./judge";
import { shiftsRouter } from "./shifts";
import { leaderboardRouter } from "./leaderboard";
import { campaignRouter } from "./campaign";
import { postsRouter } from "./posts";
import { userRouter } from "./user";
import { shopsRouter } from "./shop";
import { feedbackRouter } from "./feedback";

export const appRouter = express.Router();

appRouter.get("/", (_req: Request, res: Response) => {
    res.status(200).json({ status: "OK", message: "Server is healthy" });
});

appRouter.use("/auth", authRouter);
appRouter.use("/judge", judgeRouter);
appRouter.use("/shifts", shiftsRouter);
appRouter.use("/leaderboard", leaderboardRouter);
appRouter.use("/campaign", campaignRouter);
appRouter.use("/posts", postsRouter);
appRouter.use("/users", userRouter);
appRouter.use("/shops", shopsRouter);
appRouter.use("/feedback", feedbackRouter);

export type AppRouter = typeof appRouter;
