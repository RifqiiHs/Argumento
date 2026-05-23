import type { Request, Response } from "express";
import Feedback from "@/db/models/Feedback";

export const submitFeedback = async (req: Request, res: Response) => {
    try {
        const userId = req.users;
        const {
            description,
            expectation,
            favoritePart,
            frustrated,
            clarity,
            playAgainTomorrow,
            improvements,
            learnedSomething,
            changesSocialMedia,
            anythingElse,
        } = req.body;

        const feedback = new Feedback({
            userId,
            description,
            expectation,
            favoritePart,
            frustrated,
            clarity,
            playAgainTomorrow,
            improvements,
            learnedSomething,
            changesSocialMedia,
            anythingElse,
        });

        await feedback.save();

        res.status(201).json({
            success: true,
            message: "Thank you for your feedback!",
            feedback,
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

export const getFeedbackAnalytics = async (_req: Request, res: Response) => {
    try {
        const allFeedback = await Feedback.find();

        const analytics = {
            totalResponses: allFeedback.length,
            avgRetention: (
                allFeedback.reduce((sum, f) => sum + f.playAgainTomorrow, 0) /
                allFeedback.length
            ).toFixed(2),
            avgClarity: (
                allFeedback.reduce((sum, f) => sum + f.clarity, 0) /
                allFeedback.length
            ).toFixed(2),
            expectations: {
                better: allFeedback.filter((f) => f.expectation === "better")
                    .length,
                same: allFeedback.filter((f) => f.expectation === "same")
                    .length,
                worse: allFeedback.filter((f) => f.expectation === "worse")
                    .length,
            },
            learnedDistribution: {
                yes_lot: allFeedback.filter(
                    (f) => f.learnedSomething === "yes_lot",
                ).length,
                yes_little: allFeedback.filter(
                    (f) => f.learnedSomething === "yes_little",
                ).length,
                not_really: allFeedback.filter(
                    (f) => f.learnedSomething === "not_really",
                ).length,
                already_knew: allFeedback.filter(
                    (f) => f.learnedSomething === "already_knew",
                ).length,
            },
            changeBehavior: {
                yes: allFeedback.filter((f) => f.changesSocialMedia === "yes")
                    .length,
                maybe: allFeedback.filter(
                    (f) => f.changesSocialMedia === "maybe",
                ).length,
                probably_not: allFeedback.filter(
                    (f) => f.changesSocialMedia === "probably_not",
                ).length,
                no: allFeedback.filter((f) => f.changesSocialMedia === "no")
                    .length,
            },
        };

        res.status(200).json({
            success: true,
            analytics,
            allFeedback,
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
