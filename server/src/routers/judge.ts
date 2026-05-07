import { authMiddleware } from "@/middleware/auth";
import { judge } from "@/controllers/judge";
import express from "express";

export const judgeRouter = express.Router();

judgeRouter.post("/", authMiddleware, judge);

export type JudgeRouter = typeof judgeRouter;
