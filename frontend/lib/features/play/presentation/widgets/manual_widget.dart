import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ManualWidget extends StatelessWidget {
  const ManualWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.zinc950,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FIELD MANUAL',
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Reference guide for identifying logical flaws.',
              style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc500),
            ),
            const SizedBox(height: 16),
            ..._sections.map((s) => _ManualSection(title: s['title']!, entries: s['entries']!)),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _sections = [
  {
    'title': 'LOGICAL FALLACIES',
    'entries': [
      {'name': 'Ad Hominem', 'desc': 'Attacking the person making the argument rather than the argument itself.'},
      {'name': 'Strawman', 'desc': "Misrepresenting someone's position to make it easier to attack."},
      {'name': 'False Dichotomy', 'desc': 'Presenting only two options when more exist.'},
      {'name': 'Slippery Slope', 'desc': 'Claiming one event will inevitably lead to extreme consequences.'},
      {'name': 'Appeal to Authority', 'desc': 'Using authority as evidence without further support.'},
      {'name': 'Circular Reasoning', 'desc': 'Using the conclusion as a premise to support itself.'},
      {'name': 'Hasty Generalization', 'desc': 'Drawing broad conclusions from insufficient evidence.'},
      {'name': 'Red Herring', 'desc': 'Introducing an irrelevant topic to divert attention.'},
    ],
  },
  {
    'title': 'COGNITIVE BIASES',
    'entries': [
      {'name': 'Confirmation Bias', 'desc': 'Favoring information that confirms existing beliefs.'},
      {'name': 'Availability Heuristic', 'desc': 'Overestimating the likelihood of events based on how easily they come to mind.'},
      {'name': 'Anchoring Bias', 'desc': 'Over-relying on the first piece of information encountered.'},
      {'name': 'Bandwagon Effect', 'desc': 'Adopting beliefs because many others hold them.'},
      {'name': 'Dunning-Kruger', 'desc': 'Overestimating competence in areas of limited knowledge.'},
    ],
  },
  {
    'title': 'MEDIA MANIPULATION',
    'entries': [
      {'name': 'Clickbait', 'desc': 'Sensationalized headlines that misrepresent content.'},
      {'name': 'Framing Effect', 'desc': 'Presenting information in a way that influences interpretation.'},
      {'name': 'Cherry Picking', 'desc': 'Selecting only favorable evidence while ignoring contradictory data.'},
      {'name': 'False Balance', 'desc': 'Giving equal weight to unequal positions.'},
      {'name': 'Emotional Manipulation', 'desc': 'Using emotional language to bypass critical thinking.'},
    ],
  },
  {
    'title': 'AI HALLUCINATIONS',
    'entries': [
      {'name': 'Fabricated Citations', 'desc': 'References to studies, quotes, or sources that do not exist.'},
      {'name': 'False Expertise', 'desc': 'Presenting fabricated credentials or institutions as authoritative.'},
      {'name': 'Plausible Fabrication', 'desc': 'Generating convincing-sounding but entirely false information.'},
      {'name': 'Overconfident Claims', 'desc': 'Presenting uncertain or false information with complete certainty.'},
    ],
  },
];

class _ManualSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> entries;

  const _ManualSection({required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.zinc800))),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.zinc500,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...entries.map((e) => _ManualEntry(name: e['name']!, desc: e['desc']!)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ManualEntry extends StatelessWidget {
  final String name;
  final String desc;

  const _ManualEntry({required this.name, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      color: AppColors.zinc900.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 12,
              color: AppColors.zinc400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
