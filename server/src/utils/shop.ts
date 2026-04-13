import type { ShopConfig } from "@/types";

export const shop: ShopConfig = {
    themes: [
        {
            id: "theme_green",
            name: "Terminal Green",
            description: "Simple, reliable",
            price: 0,
            class: "text-green-500 border-green-500 selection:bg-green-500",
            hex: "#22c55e",
        },
        {
            id: "theme_obsidian",
            name: "Void White",
            description: "Minimalist!",
            price: 100,
            class: "text-zinc-100 border-zinc-100 selection:bg-black",
            hex: "#f4f4f5",
        },
        {
            id: "theme_amber",
            name: "Amber Orange",
            description: "Danger danger",
            price: 500,
            class: "text-amber-500 border-amber-500 selection:bg-amber-500",
            hex: "#f59e0b",
        },
        {
            id: "theme_cyan",
            name: "Nocturnal Cyan",
            description: "Doesn't include heater",
            price: 750,
            class: "text-cyan-400 border-cyan-400 selection:bg-cyan-400",
            hex: "#22d3ee",
        },
        {
            id: "theme_red",
            name: "Critical Red",
            description: "Villain arc 🗣️🗣️",
            price: 1000,
            class: "text-red-500 border-red-500 selection:bg-red-500",
            hex: "#ef4444",
        },
    ],
};
