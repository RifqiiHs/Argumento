import User from "@/db/models/User";
import { campaign_level } from "@/utils/campaign";
import type { Request, Response } from "express";

export const getLevel = async (req: Request, res: Response) => {
    try {
        const { level, id } = req.params as { level: string; id: string };
        const campaign = campaign_level[level as keyof typeof campaign_level];
        const part = campaign.levels[id as keyof typeof campaign.levels];
        res.status(200).json({
            success: true,
            message: "Success",
            part,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};
export const getCampaign = async (_req: Request, res: Response) => {
    try {
        res.status(200).json({ success: true, campaign: campaign_level });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};
export const completeCampaignLevel = async (req: Request, res: Response) => {
    try {
        const { level, id } = req.params as { level: string; id: string };

        const userId = req.users;

        if (!userId) {
            return res.status(401).send({
                success: false,
                message: "Unauthorized",
            });
        }

        const user = await User.findById(userId);

        if (!user) {
            return res.status(401).send({
                success: false,
                message: "Unauthorized",
            });
        }

        const campaign = campaign_level[level as keyof typeof campaign_level];
        if (!campaign) {
            return res.status(404).json({
                success: false,
                message: "Campaign not found",
            });
        }

        const campaignProgress = user.campaign_progress.find(
            (cp) => cp.campaign_id === level
        );

        const totalLevelsCompleted = Object.keys(campaign.levels).length;

        if (campaignProgress) {
            if (!campaignProgress.levelsCompleted.includes(id)) {
                campaignProgress.levelsCompleted.push(id);
            }

            if (
                campaignProgress.levelsCompleted.length >= totalLevelsCompleted
            ) {
                campaignProgress.isCompleted = true;
            }
        } else {
            user.campaign_progress.push({
                campaign_id: level,
                isCompleted: false,
                levelsCompleted: [id],
            });
        }

        await user.save();

        res.status(200).json({ success: true, message: "Success" });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};
