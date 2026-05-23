import { equipTheme, getUserById, refreshStreak } from "@/controllers/user";
import { authMiddleware } from "@/middleware/auth";
import express from "express";

export const userRouter = express.Router();

userRouter.get("/:userId", getUserById);
userRouter.put("/theme", authMiddleware, equipTheme);
userRouter.put("/streak", authMiddleware, refreshStreak);

export type UserRouter = typeof userRouter;
