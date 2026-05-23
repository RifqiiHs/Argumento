import mongoose, { Schema, type Document } from "mongoose";

export interface IPosts extends Document {
    headline: string;
    content: string;
    type: "slop" | "safe";
    slop_reason?: string | null;
    category?:
        | "logical_fallacies"
        | "cognitive_biases"
        | "media_manipulation"
        | "ai_hallucinations"
        | "safe";
    reasons: string[];
    origin: "human" | "ai";
}

const PostsSchema: Schema = new Schema(
    {
        headline: {
            type: String,
            required: true,
        },
        content: {
            type: String,
            required: true,
        },
        type: {
            type: String,
            enum: ["safe", "slop"],
            required: true,
        },
        category: {
            type: String,
            enum: [
                "logical_fallacies",
                "cognitive_biases",
                "media_manipulation",
                "ai_hallucinations",
                "safe",
            ],
            required: true,
        },
        reasons: [
            {
                type: String,
                default: null,
            },
        ],
        origin: {
            type: String,
            enum: ["ai", "human"],
            required: true,
        },
    },
    {
        timestamps: true,
    }
);

export default mongoose.model<IPosts>("Posts", PostsSchema);
