import type { Request, Response } from "express";
import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";

dotenv.config();

const ai = new GoogleGenAI({
    apiKey: process.env.GEMINI_AI_API,
});

export const judge = async (req: Request, res: Response) => {
    try {
        const { headline, content, slop_reasons, user_reason } = req.body;
        const response = await ai.models.generateContent({
            model: "gemini-2.5-flash-lite",
            contents: `
        ROLE: You are an impartial referee for a logic game.
        
        THE POST:
        Headline: "${headline}"
        Content: "${content}"
        
        OFFICIAL VIOLATIONS (HIDDEN TRUTH): 
        ${JSON.stringify(slop_reasons)}
        
        USER'S ARGUMENT:
        "${user_reason}"
        
        TASK:
        Does the user correctly identify AT LEAST ONE of the official violations?
        
        RULES:
        - If the user identifies a valid logical flaw that is in the "OFFICIAL VIOLATIONS" list, mark as CORRECT.
        - If the user identifies a valid flaw that is NOT in the list but is clearly present in the text, mark as CORRECT (be generous).
        - If the user is vague, off-topic, or defending the slop, mark as INCORRECT.
        
        OUTPUT JSON:
        {
            "is_correct": boolean,
            "feedback_message": "string (Short feedback explaining why they are right/wrong. Mention the official tags.)"
        }`,
        });

        return res.status(200).json({
            success: true,
            message: "Success",
            response: JSON.parse(
                response?.candidates?.[0]?.content?.parts?.[0]?.text
                    ?.replace("```json\n", "")
                    .replace("\n```", "") || ""
            ),
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: "Server error",
            error,
        });
    }
};
