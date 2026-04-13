import type { Request, Response } from "express";
import Posts from "@/db/models/Posts";

export const getPost = async (req: Request, res: Response) => {
    try {
        const { postId } = req.params;

        const post = await Posts.findById(postId);

        if (!post) {
            return res.status(404).json({
                success: false,
                message: "Post not found",
            });
        }

        return res.status(200).json({
            success: true,
            post,
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
