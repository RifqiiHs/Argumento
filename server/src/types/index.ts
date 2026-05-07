// Game Mechanics

export interface IPostLog {
    post_id: string;
    is_correct: boolean;
}

export interface IPostVerdict {
    post_id: string;
    message: string;
}

export interface IPost {
    id: string;
    _id: string;
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
    reasons: string[] | [];
    origin: "human" | "ai";
    createdAt: Date;
    updatedAt: Date;
}

export interface ICampaignPost {
    id: string;
    headline: string;
    content: string;
    type: "safe" | "slop";
    slop_reasons: string[];
    category: "safe" | "media_manipulation" | "fallacies" | "biases";
}

export interface ICampaignLevel {
    title: string;
    briefing: string;
    posts: ICampaignPost[];
}

export interface ICampaign {
    title: string;
    description: string;
    requirement: string;
    levels: Record<string, ICampaignLevel>;
}

export type ICampaignMap = Record<string, ICampaign>;

export interface ShopTheme {
    id: string;
    name: string;
    description: string;
    price: number;
    class: string;
    hex: string;
}

export interface ShopConfig {
    themes: ShopTheme[];
}

// User Model
export interface IPostHistory {
    is_correct: boolean;
    post: IPost;
}
export interface ICampaignProgress {
    campaign_id: string;
    isCompleted: boolean;
    levelsCompleted: string[];
}

export interface IStat {
    stat_id: string;
    name: string;
    correct: number;
    total: number;
}

export interface IUser {
    _id: string;
    username: string;
    password: string;
    totalExp: number;
    totalCoins: number;

    currentStreak: number;
    bestStreak: number;
    lastPlayedDate: Date | null;
    postsProcessed: number;
    postsCorrect: number;

    postsHistory: IPostHistory[];
    stats: IStat[];
    campaign_progress: ICampaignProgress[];

    activeTheme: string;
    inventory: {
        themes: string[];
        consumables: {
            itemId: string;
            amount: number;
        }[];
    };

    createdAt: Date;
    updatedAt: Date;
}

// API Type
export interface IApiResponse<T> {
    success: boolean;
    data: T;
    message?: string;
}
