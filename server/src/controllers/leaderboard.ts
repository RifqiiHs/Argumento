import type { Request, Response } from "express";
import User from "@/db/models/User";

export const getLeaderboard = async (req: Request, res: Response) => {
    try {
        const { type = "totalExp" } = req.params;

        const sortType =
            type === "totalExp"
                ? "Total EXP"
                : type === "bestStreak"
                  ? "Best Streak"
                  : type === "currentStreak"
                    ? "Current Streak"
                    : type === "postsProcessed"
                      ? "Post Processed"
                      : "Posts Correct";

        const data = await User.find({}, "-password")
            .sort({ [type]: -1 })
            .limit(100);
        res.status(200).json({
            success: true,
            message: "Success",
            data,
            type: sortType,
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
