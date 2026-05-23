import {
    deleteAccount,
    generateResetToken,
    getMe,
    login,
    register,
    resetPassword,
    sendVerifyEmail,
    verifyEmail,
} from "@/controllers/auth";
import { authMiddleware } from "@/middleware/auth";
import express from "express";

export const authRouter = express.Router();

authRouter.post("/login", login);
authRouter.post("/register", register);
authRouter.get("/", authMiddleware, getMe);
authRouter.post("/verify", sendVerifyEmail);
authRouter.put("/verify/:id", verifyEmail);
authRouter.post("/reset", generateResetToken);
authRouter.put("/reset/:id", resetPassword);
authRouter.delete("/", authMiddleware, deleteAccount);

export type AuthRouter = typeof authRouter;
