import mongoose from "mongoose";

const FeedbackSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: false,
    },
    description: {
        type: String,
        required: true,
    },
    expectation: {
        type: String,
        enum: ["better", "same", "worse"],
        required: true,
    },
    favoritePart: {
        type: String,
        required: true,
    },
    frustrated: {
        type: String,
        required: true,
    },
    clarity: {
        type: Number,
        min: 1,
        max: 4,
        required: true,
    },
    playAgainTomorrow: {
        type: Number,
        min: 1,
        max: 5,
        required: true,
    },
    improvements: {
        type: String,
        required: true,
    },
    learnedSomething: {
        type: String,
        enum: ["yes_lot", "yes_little", "not_really", "already_knew"],
        required: true,
    },
    changesSocialMedia: {
        type: String,
        enum: ["yes", "maybe", "probably_not", "no"],
        required: true,
    },
    anythingElse: {
        type: String,
        required: false,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

const Feedback = mongoose.model("Feedback", FeedbackSchema);

export default Feedback;
