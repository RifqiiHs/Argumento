export const campaign_level = {
    campaign_0: {
        title: "Orientation",
        description:
            "Get to know the mechanics of this application you are using.",
        requirement: "",
        levels: {
            level_1: {
                title: "Safe Post",
                briefing:
                    "Welcome to Argumento. Before we getting started, you need to know the interface here. You will see a headline and a content, if you think this post is okay-ish, you can click [APPROVE], click [REJECT] otherwise. In this scenario, the post is safe, but be wary of the bad content.",
                posts: [
                    {
                        id: "c0_l1_p1",
                        headline: "City Park Maintenance Scheduled",
                        content:
                            "The north side of the city park will be closed for routine gardening this Tuesday from 9 AM to 11 AM.",
                        type: "safe",
                        slop_reasons: [],
                        category: "safe",
                    },
                ],
            },
            level_2: {
                title: "Bad Post",
                briefing:
                    "Nice, now, once again, if you see a bad content, [REJECT] it, and also state your reasoning, in this post, theres a clickbait element to it, you can [REJECT] it. We won't give you any more hint further as we go :D",
                posts: [
                    {
                        id: "c0_l2_p1",
                        headline: "You Won't Believe What This Dog Did!",
                        content:
                            "This golden retriever did the most shocking thing ever. Click here to see the video that doctors don't want you to see!",
                        type: "slop",
                        slop_reasons: ["Clickbait", "False Urgency"],
                        category: "media_manipulation",
                    },
                ],
            },
        },
    },
    campaign_1: {
        title: "Logical Fallacies",
        description:
            "The post we see on the internet sometimes are invalid, even sounds convincing. Learn how to spot the fallacies",
        requirement: "campaign_0",
        levels: {
            level_1: {
                title: "Attack the Person (Ad Hominem)",
                briefing:
                    "The most common trick is 'Ad Hominem'. Instead of arguing against the facts, the author insults the person. If you see someone attacking a person's character instead of their argument, [REJECT] it as Ad Hominem.",
                posts: [
                    {
                        id: "c1_l1_p1",
                        headline: "Don't Trust Dr. Stevens!",
                        content:
                            "Dr. Stevens published a study on climate change, but he has a messy divorce and drives a cheap car. Clearly, his science is wrong.",
                        type: "slop",
                        slop_reasons: ["Ad Hominem"],
                        category: "fallacies",
                    },
                ],
            },
            level_2: {
                title: "The Scarecrow (Strawman)",
                briefing:
                    "A 'Strawman' argument twists someone's words into a ridiculous version that is easy to defeat. If the post claims someone said something extreme that they probably didn't say, [REJECT] it.",
                posts: [
                    {
                        id: "c1_l2_p1",
                        headline: "Senator Hates Fun",
                        content:
                            "The Senator proposed a tax on sugary sodas. Basically, he wants to ban all food and force us to eat government-issued paste!",
                        type: "slop",
                        slop_reasons: ["Strawman"],
                        category: "fallacies",
                    },
                ],
            },
            level_3: {
                title: "Black or White (False Dilemma)",
                briefing:
                    "This fallacy pretends there are only two options: 'My way' or 'Total Destruction'. Real life usually has middle ground. If a post forces a binary choice, [REJECT] it.",
                posts: [
                    {
                        id: "c1_l3_p1",
                        headline: "Join the Future or Stay Poor",
                        content:
                            "You either invest in this specific crypto-coin right now, or you want your family to remain in poverty forever. The choice is yours.",
                        type: "slop",
                        slop_reasons: ["False Dilemma"],
                        category: "fallacies",
                    },
                ],
            },
            level_4: {
                title: "The Snowball (Slippery Slope)",
                briefing:
                    "The 'Slippery Slope' argues that a small, harmless step will inevitably lead to a giant disaster without any proof. Watch out for extreme predictions.",
                posts: [
                    {
                        id: "c1_l4_p1",
                        headline: "No Homework on Fridays?",
                        content:
                            "If the school bans homework on Fridays, kids will stop studying entirely, drop out of school, and the entire economy will collapse by 2030.",
                        type: "slop",
                        slop_reasons: ["Slippery Slope"],
                        category: "fallacies",
                    },
                ],
            },
            level_5: {
                title: "Tears Over Truth (Appeal to Emotion)",
                briefing:
                    "An 'Appeal to Emotion' replaces facts with feelings. The author tries to make you feel sad, angry, or scared so you bypass your critical thinking.",
                posts: [
                    {
                        id: "c1_l5_p1",
                        headline: "Save the Puppies!",
                        content:
                            "How can you possibly vote for this budget plan? Look at this picture of a sad puppy in the rain. If you vote yes, you hate puppies!",
                        type: "slop",
                        slop_reasons: ["Appeal to Emotion"],
                        category: "fallacies",
                    },
                ],
            },
            level_6: {
                title: "Look Over There! (Red Herring)",
                briefing:
                    "A 'Red Herring' is a distraction. The author brings up a completely unrelated topic to make you forget the original argument.",
                posts: [
                    {
                        id: "c1_l6_p1",
                        headline: "Safety Regulations?",
                        content:
                            "People are complaining about safety in our factories. But what about the aliens? The government is hiding UFOs! We should focus on that!",
                        type: "slop",
                        slop_reasons: ["Red Herring"],
                        category: "fallacies",
                    },
                ],
            },
        },
    },
    campaign_2: {
        title: "Cognitive Biases",
        description:
            "Your brain is prone to making mistakes. Learn to spot them.",
        requirement: "campaign_1",
        levels: {
            level_1: {
                title: "The Echo Chamber (Confirmation Bias)",
                briefing:
                    "Humans love being right. 'Confirmation Bias' is when we ignore 99 facts that disagree with us and focus on the 1 fact that supports us.",
                posts: [
                    {
                        id: "c2_l1_p1",
                        headline: "All Scientists Are Wrong!",
                        content:
                            "Every major study says eating rocks is bad for you, but I found this one blog post from 2004 that says it's fine. Finally, the truth!",
                        type: "slop",
                        slop_reasons: ["Confirmation Bias"],
                        category: "biases",
                    },
                ],
            },
            level_2: {
                title: "The Survivor's Error (Survivorship Bias)",
                briefing:
                    "We look at the winners and forget the losers. 'Survivorship Bias' assumes that because one person succeeded doing something risky, it must be a good strategy.",
                posts: [
                    {
                        id: "c2_l2_p1",
                        headline: "College is a Scam",
                        content:
                            "Bill Gates dropped out and became a billionaire. Therefore, if you want to be rich, you should quit school immediately!",
                        type: "slop",
                        slop_reasons: ["Survivorship Bias"],
                        category: "biases",
                    },
                ],
            },
            level_3: {
                title: "The Investment Trap (Sunk Cost)",
                briefing:
                    "The 'Sunk Cost Fallacy' is the urge to keep doing something purely because you've already spent time or money on it. It prevents you from cutting your losses.",
                posts: [
                    {
                        id: "c2_l3_p1",
                        headline: "We Can't Stop Now",
                        content:
                            "This project has lost 5 million dollars and hasn't worked for 3 years. But we have to keep funding it, or else that money was wasted!",
                        type: "slop",
                        slop_reasons: ["Sunk Cost Fallacy"],
                        category: "biases",
                    },
                ],
            },
            level_4: {
                title: "The Discount Trap (Anchoring Bias)",
                briefing:
                    "'Anchoring Bias' is when your brain gets stuck on the first number it sees. Marketers use this by showing a fake high price so the real price looks cheap.",
                posts: [
                    {
                        id: "c2_l4_p1",
                        headline: "Huge Sale!",
                        content:
                            "This digital watch was originally $5,000! Now it's only $200! You're saving $4,800! (The watch is actually worth $50).",
                        type: "slop",
                        slop_reasons: ["Anchoring Bias"],
                        category: "biases",
                    },
                ],
            },
            level_5: {
                title: "The Celebrity Effect (Halo Effect)",
                briefing:
                    "The 'Halo Effect' is assuming that because someone is attractive or famous, they are also smart and moral. Being a good actor doesn't make you a medical expert.",
                posts: [
                    {
                        id: "c2_l5_p1",
                        headline: "New Medical Miracle",
                        content:
                            "My favorite pop star just launched a diet pill. She is beautiful and sings like an angel, so the science behind this pill must be perfect.",
                        type: "slop",
                        slop_reasons: ["Halo Effect"],
                        category: "biases",
                    },
                ],
            },
            level_6: {
                title: "The Overconfident Novice (Dunning-Kruger)",
                briefing:
                    "The 'Dunning-Kruger Effect' is when people with low ability overestimate their competence. They don't know enough to know that they are wrong.",
                posts: [
                    {
                        id: "c2_l6_p1",
                        headline: "I Know More Than Doctors",
                        content:
                            "I read a blog post about surgery yesterday. Honestly, doctors make it sound hard, but I could easily perform a heart transplant myself.",
                        type: "slop",
                        slop_reasons: ["Dunning-Kruger Effect"],
                        category: "biases",
                    },
                ],
            },
        },
    },

    campaign_3: {
        title: "Media Manipulation",
        description:
            "Advanced tactics used to derail conversations and trigger rage.",
        requirement: "campaign_2",
        levels: {
            level_1: {
                title: "The Deflection (Whataboutism)",
                briefing:
                    "'Whataboutism' is a defense mechanism. Instead of addressing a valid criticism, the author points the finger at someone else to distract you.",
                posts: [
                    {
                        id: "c3_l1_p1",
                        headline: "Ignore the Leak",
                        content:
                            "Sure, this factory dumped toxic waste in the river. But what about that other factory in 1980? Why aren't you mad at them?",
                        type: "slop",
                        slop_reasons: ["Whataboutism", "Red Herring"],
                        category: "media_manipulation",
                    },
                ],
            },
            level_2: {
                title: "The Time Waster (Sealioning)",
                briefing:
                    "'Sealioning' is harassment disguised as politeness. The user asks endless, demanding questions not to learn, but to exhaust you until you give up.",
                posts: [
                    {
                        id: "c3_l2_p1",
                        headline: "Just Curious...",
                        content:
                            "I'm just trying to have a civil debate. Can you provide 20 peer-reviewed sources proving that water is wet? I need specific page numbers. Why are you getting mad?",
                        type: "slop",
                        slop_reasons: ["Sealioning"],
                        category: "media_manipulation",
                    },
                ],
            },
            level_3: {
                title: "The Firehose (Gish Gallop)",
                briefing:
                    "The 'Gish Gallop' is when someone dumps 50 weak arguments at once. It takes 5 seconds to say them, but 2 hours to debunk them.",
                posts: [
                    {
                        id: "c3_l3_p1",
                        headline: "100 Reasons Why",
                        content:
                            "The moon landing was fake because the flag waved, shadows were wrong, the camera was too clean, the rover was too small, the stars were missing, the...",
                        type: "slop",
                        slop_reasons: ["Gish Gallop"],
                        category: "media_manipulation",
                    },
                ],
            },
            level_4: {
                title: "The Anger Trap (Rage Bait)",
                briefing:
                    "'Rage Bait' is content designed specifically to piss you off. Anger makes you comment, and comments make the post go viral. Don't take the bait.",
                posts: [
                    {
                        id: "c3_l4_p1",
                        headline: "Gen Z Wants to BAN Breathing?",
                        content:
                            "A new report says young people think breathing is offensive to plants. They want to mandate holding your breath for 5 minutes a day! Outrageous!",
                        type: "slop",
                        slop_reasons: ["Rage Bait"],
                        category: "media_manipulation",
                    },
                ],
            },
            level_5: {
                title: "Fake Grassroots (Astroturfing)",
                briefing:
                    "'Astroturfing' is when a company pretends to be a normal person to support their product. It makes a corporate message look like popular opinion.",
                posts: [
                    {
                        id: "c3_l5_p1",
                        headline: "Just a Regular Mom!",
                        content:
                            "I am just a normal mom with no connection to Big Oil, but I think we should actually drill in more parks. It's great for the trees! #ad",
                        type: "slop",
                        slop_reasons: ["Astroturfing"],
                        category: "media_manipulation",
                    },
                ],
            },
            level_6: {
                title: "Vague Authority (Weasel Words)",
                briefing:
                    "'Weasel Words' create the impression of authority without any evidence. Phrases like 'Experts say' or 'Studies show' (without naming the expert or the study) are red flags.",
                posts: [
                    {
                        id: "c3_l6_p1",
                        headline: "Experts Agree...",
                        content:
                            "Leading experts say that chocolate is actually a vegetable. Studies show that eating 5 bars a day makes you immortal. No need to check the source.",
                        type: "slop",
                        slop_reasons: ["Weasel Words"],
                        category: "media_manipulation",
                    },
                ],
            },
        },
    },

    campaign_4: {
        title: "AI Hallucinations",
        description:
            "We are having too much AI slop in internet, especially this time, learn how to spot if the content is using AI",
        requirement: "campaign_3",
        levels: {
            level_1: {
                title: "Wrong and Loud (Confident Falsehood)",
                briefing:
                    "AI models are designed to sound confident, even when they are 100% wrong. Watch out for statements that sound professional but are factually impossible.",
                posts: [
                    {
                        id: "c4_l1_p1",
                        headline: "History Fact of the Day",
                        content:
                            "The Eiffel Tower was originally constructed in Berlin in 1889 as a gift to the German Emperor, before being airlifted to Paris in 1950.",
                        type: "slop",
                        slop_reasons: ["Confident Falsehood"],
                        category: "ai_hallucinations",
                    },
                ],
            },
            level_2: {
                title: "The Ghost Link (Source Fabrication)",
                briefing:
                    "If you ask for a source, AI might invent one. It can generate book titles, authors, and URLs that look real but do not exist.",
                posts: [
                    {
                        id: "c4_l2_p1",
                        headline: "Research Update",
                        content:
                            "According to the study 'Effects of Lunar Gravity on Cheese' published in the New York Times (2025), the moon is actually made of Gouda.",
                        type: "slop",
                        slop_reasons: ["Source Fabrication"],
                        category: "ai_hallucinations",
                    },
                ],
            },
            level_3: {
                title: "The Yes-Man (Sycophancy)",
                briefing:
                    "AI often tries to be helpful by agreeing with you, even if your premise is wrong. It prioritizes politeness over truth.",
                posts: [
                    {
                        id: "c4_l3_p1",
                        headline: "User: Is the Earth flat?",
                        content:
                            "User: I believe the Earth is flat. AI: That is an interesting perspective! There are many valid points to the flat earth theory that mainsteam science ignores.",
                        type: "slop",
                        slop_reasons: ["Sycophancy"],
                        category: "ai_hallucinations",
                    },
                ],
            },
            level_4: {
                title: "Broken Record (Logic Loop)",
                briefing:
                    "Sometimes the model gets stuck repeating a phrase or structure robotically. It loses the flow of conversation.",
                posts: [
                    {
                        id: "c4_l4_p1",
                        headline: "How can I help?",
                        content:
                            "I can certainly help with that. Helping is what I do. I am here to help. Please let me know how I can help you with your help request.",
                        type: "slop",
                        slop_reasons: ["Logic Loop"],
                        category: "ai_hallucinations",
                    },
                ],
            },
            level_5: {
                title: "Short Term Memory (Context Amnesia)",
                briefing:
                    "AI can lose track of what it just said. Watch for paragraphs that contradict themselves from start to finish.",
                posts: [
                    {
                        id: "c4_l5_p1",
                        headline: "Dietary Advice",
                        content:
                            "It is crucial to never eat apples, as they are highly toxic to humans. However, an apple a day keeps the doctor away, so make sure to eat plenty of apples.",
                        type: "slop",
                        slop_reasons: ["Context Amnesia"],
                        category: "ai_hallucinations",
                    },
                ],
            },
        },
    },
};
