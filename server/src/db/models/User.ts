import mongoose, {
    type Document,
    type InferSchemaType,
    Schema,
} from "mongoose";

export interface IUsers extends Document {
    _id: string;
    username: string;
    email: string;
    password: string;
    isVerified: boolean;

    totalExp: number;
    totalCoins: number;

    currentStreak: number;
    bestStreak: number;
    lastPlayedDate: Date | null;
    postsProcessed: number;
    postsCorrect: number;

    postsHistory: IPostHistoryItem[];
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

    verifyToken: string | null;
    verifyTokenGeneratedAt: Date | null;
    verifyTokenExpiry: Date | null;

    resetToken: string | null;
    resetTokenGeneratedAt: Date | null;
    resetTokenExpiry: Date | null;

    createdAt: Date;
    updatedAt: Date;
}

const StatSchema = new Schema(
    {
        stat_id: { type: String, required: true },
        name: { type: String, required: true },
        correct: { type: Number, default: 0 },
        total: { type: Number, default: 0 },
    },
    { _id: false }
);

export type IStat = InferSchemaType<typeof StatSchema>;

const CampaignProgressSchema = new Schema(
    {
        campaign_id: { type: String, required: true },
        isCompleted: { type: Boolean, default: false },
        levelsCompleted: [{ type: String }],
    },
    { _id: false }
);

export type ICampaignProgress = InferSchemaType<typeof CampaignProgressSchema>;

export interface IPostHistoryItem {
    post_id: string;
    is_correct: boolean;
}

const UsersSchema: Schema = new Schema(
    {
        username: { type: String, required: true, unique: true },
        email: { type: String, required: true, unique: true },
        password: { type: String, required: true },
        isVerified: { type: Boolean, default: false },

        totalExp: { type: Number, default: 0 },
        totalCoins: { type: Number, default: 0 },

        currentStreak: { type: Number, default: 0 },
        bestStreak: { type: Number, default: 0 },
        lastPlayedDate: { type: Date, default: null },

        postsProcessed: { type: Number, default: 0 },
        postsCorrect: { type: Number, default: 0 },

        postsHistory: [
            {
                post_id: {
                    type: String,
                    required: true,
                },
                is_correct: {
                    type: Boolean,
                    required: true,
                },
            },
        ],

        stats: {
            type: [StatSchema],
        },
        campaign_progress: [CampaignProgressSchema],

        activeTheme: {
            type: String,
            default: "theme_green",
        },

        inventory: {
            themes: { type: [String], default: ["theme_green"] },

            consumables: [
                {
                    itemId: String,
                    amount: Number,
                },
            ],
        },

        verifyToken: {
            type: String,
            default: null,
        },
        verifyTokenGeneratedAt: {
            type: Date,
            default: null,
        },
        verifyTokenExpiry: {
            type: Date,
            default: null,
        },
        resetToken: {
            type: String,
            default: null,
        },
        resetTokenGeneratedAt: {
            type: Date,
            default: null,
        },
        resetTokenExpiry: {
            type: Date,
            default: null,
        },
    },
    {
        timestamps: true,
    }
);

export default mongoose.model<IUsers>("Users", UsersSchema);
