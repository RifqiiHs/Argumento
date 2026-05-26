import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

const List<Map<String, dynamic>> kContentTypes = [
  {
    'key': 'logical_fallacies',
    'name': 'Logical Fallacies',
    'description': 'Ad Hominem, Strawman, False Dichotomy and more',
    'icon': Icons.psychology_alt_rounded,
    'color': AppColors.primary,
    'requirements': null,
    'types': ['Ad Hominem', 'Strawman', 'False Dichotomy', 'Slippery Slope', 'Appeal to Authority', 'Circular Reasoning', 'Hasty Generalization', 'Red Herring'],
  },
  {
    'key': 'cognitive_biases',
    'name': 'Cognitive Biases',
    'description': 'Confirmation bias, bandwagon effect and more',
    'icon': Icons.blur_on_rounded,
    'color': AppColors.accentAmber,
    'requirements': 'campaign_1',
    'types': ['Confirmation Bias', 'Availability Heuristic', 'Anchoring Bias', 'Bandwagon Effect', 'Dunning-Kruger', 'Survivorship Bias'],
  },
  {
    'key': 'media_manipulation',
    'name': 'Media Manipulation',
    'description': 'Clickbait, framing effects and propaganda tactics',
    'icon': Icons.campaign_rounded,
    'color': AppColors.accentCyan,
    'requirements': 'campaign_1',
    'types': ['Clickbait', 'Framing Effect', 'Cherry Picking', 'False Balance', 'Emotional Manipulation', 'Dog Whistling'],
  },
  {
    'key': 'ai_hallucinations',
    'name': 'AI Hallucinations',
    'description': 'Fabricated citations, false expertise and more',
    'icon': Icons.smart_toy_rounded,
    'color': AppColors.accentRed,
    'requirements': 'campaign_2',
    'types': ['Fabricated Citations', 'False Expertise', 'Plausible Fabrication', 'Overconfident Claims'],
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
  final String mode;
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
    if (current.contains(topic)) current.remove(topic); else current.add(topic);
    updated[categoryKey] = current;
    widget.onTopicsChanged(updated);
  }

  bool _isCategoryUnlocked(Map<String, dynamic> category) {
    if (widget.mode != 'daily') return true;
    final req = category['requirements'] as String?;
    if (req == null) return true;
    return widget.user?.campaignProgress.any((cp) => cp.campaignId == req && cp.isCompleted) ?? false;
  }

  int get _totalSelected => widget.selectedTopics.values.fold(0, (sum, list) => sum + list.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: const BoxDecoration(
                color: AppColors.bg900,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.mode == 'practice' ? 'Practice Setup' : 'Daily Setup',
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('Select topics to include', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                  ]),
                  const Spacer(),
                  if (widget.mode == 'practice')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.info.withValues(alpha: 0.3))),
                      child: Text('No stats', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.info)),
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
                  final categoryColor = category['color'] as Color;
                  final selectedInCategory = (widget.selectedTopics[categoryKey] ?? []).length;

                  if (!isUnlocked) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bg800,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.bg600, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.lock_rounded, color: AppColors.textMuted, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(category['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                            Text('Complete ${category['requirements']} to unlock', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textDisabled),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                          ])),
                        ],
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg800,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selectedInCategory > 0 ? categoryColor.withValues(alpha: 0.4) : AppColors.border),
                    ),
                    child: Column(
                      children: [
                        // Category header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: categoryColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                                child: Icon(category['icon'] as IconData, color: categoryColor, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(category['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                Text(category['description'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                              ])),
                              if (selectedInCategory > 0)
                                StatusBadge(label: '$selectedInCategory selected', color: categoryColor),
                            ],
                          ),
                        ),
                        Container(height: 1, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 16)),
                        // Topics
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            spacing: 8, runSpacing: 8,
                            children: types.map((t) {
                              final isSelected = (widget.selectedTopics[categoryKey] ?? []).contains(t);
                              return GestureDetector(
                                onTap: () => _toggleTopic(categoryKey, t),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? categoryColor.withValues(alpha: 0.15) : AppColors.bg700,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: isSelected ? categoryColor.withValues(alpha: 0.5) : AppColors.border),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    if (isSelected) ...[
                                      Icon(Icons.check_rounded, size: 12, color: categoryColor),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? categoryColor : AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                  ]),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
                },
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.bg800,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Post amount
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Posts', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                Row(
                                  children: [
                                    _CounterBtn(icon: Icons.remove_rounded, onTap: widget.postAmount > 1 ? () => widget.onPostAmountChanged(widget.postAmount - 1) : null),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Text('${widget.postAmount}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    ),
                                    _CounterBtn(icon: Icons.add_rounded, onTap: widget.postAmount < 5 ? () => widget.onPostAmountChanged(widget.postAmount + 1) : null),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: AccentButton(
                            label: widget.isSubmitting ? 'Generating...' : 'Generate Shift',
                            onPressed: widget.isSubmitting ? null : widget.onStart,
                            isLoading: widget.isSubmitting,
                            accentColor: widget.accentColor,
                            icon: widget.isSubmitting ? null : const Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text('AI-generated content may occasionally be inaccurate', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                    ]),
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

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CounterBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.3 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.bg600, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
          child: Icon(icon, size: 14, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
