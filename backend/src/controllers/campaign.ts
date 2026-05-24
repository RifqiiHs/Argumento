import User from '@/models/User';
import type { Request, Response } from 'express';

// Campaign data (migrated from apps/server/src/utils/campaign.ts - abbreviated version)
// The full campaign data would be the complete campaign_level object from the original
export const campaign_level: Record<string, any> = {
  campaign_1: {
    title: 'Fallacy Fundamentals',
    description: 'Master the foundational logical fallacies used in everyday manipulation.',
    requirement: '',
    levels: {
      level_1: {
        title: 'Ad Hominem',
        briefing:
          'The Ad Hominem fallacy attacks the person making the argument rather than the argument itself. It dismisses valid points by targeting character, background, or circumstances.',
        posts: [
          {
            id: 'c1l1p1',
            headline: 'PoliticsWatch',
            content:
              "Why should we listen to Senator Reyes on climate policy? She drives an SUV! Her personal hypocrisy invalidates her entire legislative platform. 🙄",
            type: 'slop',
            slop_reasons: ['ad_hominem'],
            category: 'fallacies',
          },
          {
            id: 'c1l1p2',
            headline: 'Science Daily',
            content:
              "A new peer-reviewed study with 10,000 participants confirms: Regular 30-minute walks reduce cardiovascular risk by 35%. The data speaks for itself.",
            type: 'safe',
            slop_reasons: [],
            category: 'safe',
          },
          {
            id: 'c1l1p3',
            headline: 'DebateKing99',
            content:
              "Of course Dr. Peterson supports that economic theory — he's a consultant for the very firms that benefit! Ignore everything he says. Totally compromised. 💼",
            type: 'slop',
            slop_reasons: ['ad_hominem'],
            category: 'fallacies',
          },
        ],
      },
      level_2: {
        title: 'Strawman',
        briefing:
          "The Strawman fallacy misrepresents someone's argument to make it easier to attack. Instead of engaging with the real position, it creates a distorted version to knock down.",
        posts: [
          {
            id: 'c1l2p1',
            headline: 'PolicyDebater',
            content:
              "Progressives want to defund the police, which means they literally want criminals roaming the streets unchecked. They don't care about public safety at all. 🚨",
            type: 'slop',
            slop_reasons: ['strawman'],
            category: 'fallacies',
          },
          {
            id: 'c1l2p2',
            headline: 'EconUpdate',
            content:
              'Q3 GDP growth came in at 2.1%, slightly below the 2.4% forecast. Analysts attribute this partly to higher interest rates cooling consumer spending.',
            type: 'safe',
            slop_reasons: [],
            category: 'safe',
          },
          {
            id: 'c1l2p3',
            headline: 'ConservativeVoice',
            content:
              "Environmental activists want us to go back to living in caves with no electricity or industry. Their extreme anti-progress agenda would destroy modern civilization. 🏚️",
            type: 'slop',
            slop_reasons: ['strawman'],
            category: 'fallacies',
          },
        ],
      },
      level_3: {
        title: 'False Dichotomy',
        briefing:
          "The False Dichotomy (or False Dilemma) presents only two options when more exist. It forces an either/or choice by ignoring nuance and alternative solutions.",
        posts: [
          {
            id: 'c1l3p1',
            headline: 'ToughLove_Gary',
            content:
              "You're either with us or against us. There's no middle ground on this issue. If you don't fully support our movement, you're supporting our enemies. 🎯",
            type: 'slop',
            slop_reasons: ['false_dichotomy'],
            category: 'fallacies',
          },
          {
            id: 'c1l3p2',
            headline: 'TechReview',
            content:
              'iPhone 16 Pro benchmarks show a 15% performance improvement over iPhone 15 Pro in CPU tasks, based on standardized testing across 3 independent labs.',
            type: 'safe',
            slop_reasons: [],
            category: 'safe',
          },
          {
            id: 'c1l3p3',
            headline: 'PoliticalHotTake',
            content:
              "If you don't support this tax cut, you obviously want the economy to collapse. There's no other explanation for opposing it. Simple as that. 📉",
            type: 'slop',
            slop_reasons: ['false_dichotomy'],
            category: 'fallacies',
          },
        ],
      },
    },
  },
  campaign_2: {
    title: 'Cognitive Defense',
    description: 'Learn to identify cognitive biases that make us vulnerable to manipulation.',
    requirement: 'campaign_1',
    levels: {
      level_1: {
        title: 'Confirmation Bias',
        briefing:
          'Confirmation bias is our tendency to favor information that confirms our existing beliefs. Content designed to exploit this bias will feel deeply satisfying and "obviously true."',
        posts: [
          {
            id: 'c2l1p1',
            headline: 'TruthSeekerReal',
            content:
              "FINALLY someone said it! New study proves everything we've been saying for years. Share this before they delete it! 🔔 The mainstream refuses to cover this.",
            type: 'slop',
            slop_reasons: ['confirmation_bias_bait'],
            category: 'biases',
          },
          {
            id: 'c2l1p2',
            headline: 'ResearchHub',
            content:
              'Meta-analysis of 847 studies on sleep: Adults sleeping 7-9 hours consistently outperform on cognitive tests. Effect size: d=0.73. Replication rate: 91%.',
            type: 'safe',
            slop_reasons: [],
            category: 'safe',
          },
          {
            id: 'c2l1p3',
            headline: 'WakeUpSheeple',
            content:
              'Yet ANOTHER study confirms what we knew all along. The establishment is scrambling to hide this data. Our community has been RIGHT this whole time! 💯',
            type: 'slop',
            slop_reasons: ['confirmation_bias_bait'],
            category: 'biases',
          },
        ],
      },
      level_2: {
        title: 'Bandwagon Effect',
        briefing:
          'The Bandwagon fallacy argues something is true or good because many people believe it. "Everyone is doing it" is not evidence of correctness.',
        posts: [
          {
            id: 'c2l2p1',
            headline: 'TrendAlert99',
            content:
              "10 MILLION people can't be wrong! This investment strategy is literally changing lives. Join the movement before it's too late. Don't be the last to know! 🚀",
            type: 'slop',
            slop_reasons: ['bandwagon'],
            category: 'biases',
          },
          {
            id: 'c2l2p2',
            headline: 'MarketWatch',
            content:
              "S&P 500 fell 1.2% Thursday following Fed Chair's comments on maintaining restrictive monetary policy through Q2 2025. Tech sector led declines at -2.1%.",
            type: 'safe',
            slop_reasons: [],
            category: 'safe',
          },
        ],
      },
    },
  },
};

export const getLevel = async (req: Request, res: Response): Promise<void> => {
  try {
    const { level, id } = req.params as { level: string; id: string };
    const campaign = campaign_level[level];
    if (!campaign) {
      res.status(404).json({ success: false, message: 'Campaign not found' });
      return;
    }
    const part = campaign.levels[id];
    if (!part) {
      res.status(404).json({ success: false, message: 'Level not found' });
      return;
    }
    res.status(200).json({ success: true, message: 'Success', part });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const getCampaign = async (_req: Request, res: Response): Promise<void> => {
  try {
    res.status(200).json({ success: true, campaign: campaign_level });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};

export const completeCampaignLevel = async (req: Request, res: Response): Promise<void> => {
  try {
    const { level, id } = req.params as { level: string; id: string };
    const userId = req.users;

    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const user = await User.findById(userId);
    if (!user) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const campaign = campaign_level[level];
    if (!campaign) {
      res.status(404).json({ success: false, message: 'Campaign not found' });
      return;
    }

    const campaignProgress = user.campaign_progress.find((cp) => cp.campaign_id === level);
    const totalLevelsCompleted = Object.keys(campaign.levels).length;

    if (campaignProgress) {
      if (!campaignProgress.levelsCompleted.includes(id)) {
        campaignProgress.levelsCompleted.push(id);
      }
      if (campaignProgress.levelsCompleted.length >= totalLevelsCompleted) {
        campaignProgress.isCompleted = true;
      }
    } else {
      user.campaign_progress.push({
        campaign_id: level,
        isCompleted: false,
        levelsCompleted: [id],
      });
    }

    await user.save();
    res.status(200).json({ success: true, message: 'Success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Server error', error });
  }
};
