import {
    completeShift,
    generateDailyShift,
    generatePracticeShifts,
} from "@/controllers/shifts";
import { authMiddleware } from "@/middleware/auth";
import express from "express";

export const shiftsRouter = express.Router();

shiftsRouter.put("/complete", authMiddleware, completeShift);
shiftsRouter.post("/generate", authMiddleware, generateDailyShift);
shiftsRouter.post("/practice", authMiddleware, generatePracticeShifts);

export type ShiftsRouter = typeof shiftsRouter;
