import 'package:flutter/material.dart';
import 'package:mobile/theme/app_colors.dart';

class CampaignBriefingComponent extends StatefulWidget {
  final String campaignId;
  final String levelId;
  final String badgeText;
  final String title;
  final String briefing;
  final String description;

  const CampaignBriefingComponent({
    super.key,
    required this.campaignId,
    required this.levelId,
    required this.badgeText,
    required this.title,
    required this.briefing,
    required this.description,
  });

  @override
  State<CampaignBriefingComponent> createState() =>
      _CampaignBriefingComponentState();
}

class _CampaignBriefingComponentState extends State<CampaignBriefingComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.deepBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neon, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    color: AppColors.neon,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'MISSION BRIEFING',
                      style: const TextStyle(
                        color: AppColors.neon,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.badgeBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neon),
                    ),
                    child: Text(
                      widget.badgeText,
                      style: const TextStyle(
                        color: AppColors.neon,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: AppColors.neon),
            // Content section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OPERATION NAME',
                    style: TextStyle(color: AppColors.neon, letterSpacing: 2.4),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(height: 1, color: AppColors.panelDivider),
                  const SizedBox(height: 24),
                  // Main body with left accent
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 4, color: AppColors.neon),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          widget.briefing.isNotEmpty
                              ? widget.briefing
                              : widget.description,
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 8,
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Standing Orders box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlack,
                      border: Border.all(
                        color: AppColors.muted.withOpacity(0.4),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.neon,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'RULES',
                              style: TextStyle(
                                color: AppColors.neon,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '▸ [APPROVE] verified, factual content',
                          style: TextStyle(
                            color: AppColors.muted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '▸ [REJECT] manipulative or misleading content',
                          style: TextStyle(
                            color: AppColors.muted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
