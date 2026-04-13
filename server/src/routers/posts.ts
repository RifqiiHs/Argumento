import { getPost } from "@/controllers/posts";
import express from "express";

export const postsRouter = express.Router();

postsRouter.get("/:postId", getPost);

export type PostsRouter = typeof postsRouter;
