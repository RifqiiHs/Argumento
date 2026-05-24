import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

const List<Map<String, dynamic>> kContentTypes = [
  {
    'key': 'logical_fallacies',
    'name': 'Logical Fallacies',
    'requirements': null,
    'types': [
      'Ad Hominem', 'Strawman', 'False Dichotomy', 'Slippery Slope',
      'Appeal to Authority', 'Circular Reasoning', 'Hasty Generalization',
      'Red Herring',
    ],
  },
  {
    'key': 'cognitive_biases',
    'name': 'Cognitive Biases',
    'requirements': 'campaign_1',
    'types': [
      'Confirmation Bias', 'Availability Heuristic', 'Anchoring Bias',
      'Bandwagon Effect', 'Dunning-Kruger', 'Survivorship Bias',
    ],
  },
  {
    'key': 'media_manipulation',
    'name': 'Media Manipulation',
    'requirements': 'campaign_1',
    'types': [
      'Clickbait', 'Framing Effect', 'Cherry Picking', 'False Balance',
      'Emotional Manipulation', 'Dog Whistling',
    ],
  },
  {
    'key': 'ai_hallucinations',
    'name': 'AI Hallucinations',
    'requirements': 'campaign_2',
    'types': [
      'Fabricated Citations', 'False Expertise', 'Plausible Fabrication',
      'Overconfident Claims',
    ],
  },
];

class GameSetupWidget extends StatefulWidget {
  final UserModel? user;
  final Map<String, List<String>> selectedTopics;
  final Function(Map<String, List<String>>) onTopicsChanged;
  final int postAmount;
  final Function(int) onPostAmountChanged;
  final VoidCallback onStart;
  final bool isSubmitting;
  final String mode; // 'daily' | 'practice'
  final Color accentColor;

  const GameSetupWidget({
    super.key,
    required this.user,
    required this.selectedTopics,
    required this.onTopicsChanged,
    required this.postAmount,
    required this.onPostAmountChanged,
    required this.onStart,
    required this.isSubmitting,
    required this.mode,
    required this.accentColor,
  });

  @override
  State<GameSetupWidget> createState() => _GameSetupWidgetState();
}

class _GameSetupWidgetState extends State<GameSetupWidget> {
  void _toggleTopic(String categoryKey, String topic) {
    final updated = Map<String, List<String>>.from(widget.selectedTopics);
    final current = List<String>.from(updated[categoryKey] ?? []);
    if (current.contains(topic)) {
      current.remove(topic);
    } else {
      current.add(topic);
    }
    updated[categoryKey] = current;
    widget.onTopicsChanged(updated);
  }

  bool _isCategoryUnlocked(Map<String, dynamic> category) {
    if (widget.mode != 'daily') return true;
    final req = category['requirements'] as String?;
    if (req == null) return true;
    return widget.user?.campaignProgress.any(
          (cp) => cp.campaignId == req && cp.isCompleted,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.zinc800)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mode == 'practice' ? 'DEMO MODE' : 'CUSTOM SIMULATION',
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (widget.mode == 'practice')
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.withOpacity(0.5)),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                          child: const Text(
                            'NO STATS TRACKED',
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: kContentTypes.length,
                itemBuilder: (ctx, i) {
                  final category = kContentTypes[i];
                  final isUnlocked = _isCategoryUnlocked(category);
                  final categoryKey = category['key'] as String;
                  final types = category['types'] as List<String>;

                  if (!isUnlocked) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.zinc800, style: BorderStyle.solid),
                        color: AppColors.zinc900.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.lock, color: AppColors.zinc600, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            (category['name'] as String).toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Courier New',
                              color: AppColors.zinc500,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(border: Border.all(color: Colors.red.withOpacity(0.5))),
                            child: Text(
                              'LOCKED: Complete ${category['requirements']}',
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(color: widget.accentColor.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            (category['name'] as String).toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.accentColor,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: types.map((t) {
                            final isSelected = (widget.selectedTopics[categoryKey] ?? []).contains(t);
                            return GestureDetector(
                              onTap: () => _toggleTopic(categoryKey, t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? widget.accentColor : Colors.black,
                                  border: Border.all(color: widget.accentColor.withOpacity(0.6)),
                                ),
                                child: Text(
                                  '${isSelected ? '[X]' : '[ ]'} $t',
                                  style: TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.black : widget.accentColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom bar - Post Amount + Generate button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: widget.accentColor, width: 2)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber, color: AppColors.zinc500, size: 14),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'AI Judge and Post Generation could be wrong.',
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 10,
                              color: AppColors.zinc500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Post amount selector
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.zinc900,
                            border: Border.all(color: widget.accentColor.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'POSTS:',
                                style: TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.accentColor,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                onPressed: widget.postAmount > 1
                                    ? () => widget.onPostAmountChanged(widget.postAmount - 1)
                                    : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${widget.postAmount}',
                                  style: const TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                onPressed: widget.postAmount < 5
                                    ? () => widget.onPostAmountChanged(widget.postAmount + 1)
                                    : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AccentButton(
                            label: widget.isSubmitting ? 'Generating...' : 'Generate',
                            onPressed: widget.isSubmitting ? null : widget.onStart,
                            isLoading: widget.isSubmitting,
                            accentColor: widget.accentColor,
                            icon: const Icon(Icons.play_arrow, color: Colors.black, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
