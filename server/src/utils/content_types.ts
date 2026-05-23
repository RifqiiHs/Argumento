export const content_types = [
    {
        name: "Logical Fallacies",
        description:
            "Errors in reasoning that render an argument invalid. These are flaws in the structure of the logic itself, often used to manipulate debates.",
        types: [
            {
                name: "Ad Hominem",
                definition:
                    "Attacking the person making the argument rather than the argument itself.",
            },
            {
                name: "Strawman",
                definition:
                    "Distorting or simplifying an opponent's argument to make it easier to attack.",
            },
            {
                name: "Slippery Slope",
                definition:
                    "Asserting that a relatively small first step will inevitably lead to a chain of related (and negative) events.",
            },
            {
                name: "False Dilemma",
                definition:
                    "Presenting two extreme options as the only possibilities, when in fact more possibilities exist.",
            },
            {
                name: "Appeal to Emotion",
                definition:
                    "Manipulating an emotional response in place of a valid or compelling argument.",
            },
            {
                name: "Red Herring",
                definition:
                    "Introducing an irrelevant topic to divert attention from the original issue.",
            },
        ],
    },
    {
        name: "Cognitive Biases",
        description:
            "Systematic patterns of deviation from rationality. These are mental shortcuts that cause the brain to draw incorrect conclusions based on personal beliefs.",
        types: [
            {
                name: "Confirmation Bias",
                definition:
                    "The tendency to search for, interpret, and recall information in a way that confirms one's prior beliefs.",
            },
            {
                name: "Sunk Cost Fallacy",
                definition:
                    "Continuing a behavior or endeavor as a result of previously invested resources (time, money, effort).",
            },
            {
                name: "Anchoring Bias",
                definition:
                    "Relying too heavily on the first piece of information offered (the 'anchor') when making decisions.",
            },
            {
                name: "Halo Effect",
                definition:
                    "The tendency for positive impressions of a person (like beauty or fame) to positively influence one's opinion or feelings in other areas.",
            },
            {
                name: "Dunning-Kruger Effect",
                definition:
                    "A cognitive bias where people with low ability at a task overestimate their ability.",
            },
        ],
    },
    {
        name: "Media Manipulation",
        description:
            "Techniques used by bad actors, marketers, or bots to hack human attention, provoke rage, or manufacture artificial consensus.",
        types: [
            {
                name: "Rage Bait",
                definition:
                    "Content designed specifically to anger the viewer to increase engagement (comments, shares).",
            },
            {
                name: "False Urgency (FOMO)",
                definition:
                    "Creating a fake sense of scarcity or time pressure to force a rash decision.",
            },
            {
                name: "Astroturfing",
                definition:
                    "Masking the sponsors of a message to make it appear as though it originates from and is supported by grassroots participants.",
            },
            {
                name: "Weasel Words",
                definition:
                    "Using ambiguous words (e.g., 'experts say', 'studies show') to create an impression of authority without citing evidence.",
            },
            {
                name: "Whataboutism",
                definition:
                    "Attempting to discredit an opponent's position by charging them with hypocrisy without directly refuting or disproving their argument.",
            },
        ],
    },
    {
        name: "AI Hallucinations",
        description:
            "Errors specific to Large Language Models where the AI generates plausible-sounding but factually incorrect or nonsensical information.",
        types: [
            {
                name: "Confident Falsehood",
                definition:
                    "Stating a completely wrong fact with 100% confidence and professional tone.",
            },
            {
                name: "Source Fabrication",
                definition:
                    "Generating fake citations, book titles, or URLs that look real but do not exist.",
            },
            {
                name: "Sycophancy",
                definition:
                    "The AI agrees with the user's incorrect premise just to be helpful or polite.",
            },
            {
                name: "Logic Loop",
                definition:
                    "Repeating the same phrase or structure over and over again in a robotic manner.",
            },
            {
                name: "Context Amnesia",
                definition:
                    "Contradicting a statement made earlier in the same paragraph.",
            },
        ],
    },
];
