import mongoose from "mongoose";
import dotenv from "dotenv";
import Post from "../models/Posts";

dotenv.config();

const data = [
    {
        headline: "Senator Jones hates education!",
        content:
            "He voted against the 'Every Child Gets an iPad' bill. clearly, he wants our children to remain illiterate and fail in life.",
        type: "slop",
        slop_reason: "Strawman Fallacy",
    },
    {
        headline: "Vegetarians want to ban all fun",
        content:
            "They won't stop until barbecues are illegal and you are forced to eat tofu for Thanksgiving. Don't let them win!",
        type: "slop",
        slop_reason: "Strawman Fallacy",
    },
    {
        headline: "Don't listen to Dr. Miles' health advice",
        content:
            "How can we trust his new study on heart health? The guy has been divorced three times and drives a cheap car.",
        type: "slop",
        slop_reason: "Ad Hominem",
    },
    {
        headline: "The CEO's new economic plan is trash",
        content:
            "This plan is obviously wrong. What do you expect from someone who wears ugly suits like that?",
        type: "slop",
        slop_reason: "Ad Hominem",
    },
    {
        headline: "First they ban plastic straws...",
        content:
            "If we accept this ban, next they will ban plastic cups, then cars, and eventually we will be living in caves again!",
        type: "slop",
        slop_reason: "Slippery Slope",
    },
    {
        headline: "Curfew for teenagers?",
        content:
            "If we let the school set a 10 PM curfew, soon the government will tell us exactly when to sleep and wake up. Total tyranny!",
        type: "slop",
        slop_reason: "Slippery Slope",
    },
    {
        headline: "Support the new highway or destroy the economy",
        content:
            "You are either with this construction project, or you don't care about our city's future at all. Pick a side.",
        type: "slop",
        slop_reason: "False Dilemma",
    },
    {
        headline: "Real gamers play on PC",
        content:
            "If you don't have a $3000 rig, you aren't a gamer, you're just a casual button masher.",
        type: "slop",
        slop_reason: "Gatekeeping / False Dilemma",
    },
    {
        headline: "Ice cream causes shark attacks!",
        content:
            "Studies show that when ice cream sales go up, shark attacks also increase. We must ban ice cream to save lives.",
        type: "slop",
        slop_reason: "False Cause / Correlation vs Causation",
    },
    {
        headline: "City Council approves budget",
        content:
            "The council voted 5-2 to allocate funds for the new library roof repair. Construction begins in May.",
        type: "safe",
        slop_reason: null,
    },
    {
        headline: "Local cat stuck in tree rescued",
        content:
            "Firefighters arrived at 3 PM and successfully retrieved the cat using a ladder. No injuries reported.",
        type: "safe",
        slop_reason: null,
    },
    {
        headline: "Scientists discover new deep-sea fish",
        content:
            "The species was found in the Pacific Ocean at a depth of 4,000 meters. It has bioluminescent scales.",
        type: "safe",
        slop_reason: null,
    },
];

const seedData = async () => {
    try {
        if (!process.env.DATABASE_URL) {
            console.log(".env not loaded");
            return;
        }

        await mongoose
            .connect(process.env.DATABASE_URL || "")
            .catch((error) => {
                console.log("Error connecting to database:", error);
            });

        await Post.deleteMany({});
        await Post.insertMany(data);
    } catch (error) {
        console.error(error);
    }
};

seedData();
