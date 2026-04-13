import type { Request, Response } from "express";
import { shop } from "@/utils/shop";
import User from "@/db/models/User";

export const getShops = async (_req: Request, res: Response) => {
    try {
        res.status(200).json({ success: true, shop });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};

export const buyShopItem = async (req: Request, res: Response) => {
    try {
        const { type, itemId }: { type: string; itemId: string } = req.body;
        const userId = req.users;

        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        const item = shop[type as keyof typeof shop].find(
            (it) => it.id === itemId,
        );

        if (!item) {
            return res.status(404).json({
                success: false,
                message: "Item not found",
            });
        }

        if (user.totalCoins < item.price) {
            return res
                .status(400)
                .json({ success: false, message: "Insufficient coins" });
        }

        user.totalCoins -= item.price;
        if (type === "themes") {
            user.inventory.themes.push(itemId);
        } else {
            if (
                user.inventory[type as keyof typeof user.inventory].find(
                    (it) => typeof it === "object" && it.itemId === itemId,
                )
            ) {
                const index = user.inventory[
                    type as keyof typeof user.inventory
                ].findIndex(
                    (it) => typeof it === "object" && it.itemId === itemId,
                );
                const item =
                    user.inventory[type as keyof typeof user.inventory][index];
                if (typeof item === "object") {
                    item.amount++;
                }
            } else {
                (
                    user.inventory[
                        type as keyof typeof user.inventory
                    ] as Array<{ itemId: string; amount: number }>
                ).push({
                    itemId,
                    amount: 1,
                });
            }
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
