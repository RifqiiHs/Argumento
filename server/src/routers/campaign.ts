import { authMiddleware } from "@/middleware/auth";
import express from "express";
import {
    completeCampaignLevel,
    getCampaign,
    getLevel,
} from "@/controllers/campaign";

export const campaignRouter = express.Router();

campaignRouter.get("/:level/:id", getLevel);
campaignRouter.get("/", authMiddleware, getCampaign);
campaignRouter.post(
    "/complete/:level/:id",
    authMiddleware,
    completeCampaignLevel
);

export type CampaignRouter = typeof campaignRouter;
