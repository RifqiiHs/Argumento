import { buyShopItem, getShops } from "@/controllers/shop";
import { authMiddleware } from "@/middleware/auth";
import express from "express";

export const shopsRouter = express.Router();

shopsRouter.get("/", getShops);
shopsRouter.put("/", authMiddleware, buyShopItem);

export type ShopsRouter = typeof shopsRouter;
