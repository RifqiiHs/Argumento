import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});
  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<CampaignModel> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final campaigns = await ApiService().getCampaign();
      setState(() { _campaigns = campaigns; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: ArgumentoAppBar(title: 'Campaign'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: _isLoading
          ? LoadingOverlay(accentColor: accent)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _campaigns.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text('Structured challenges to master specific reasoning skills.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.5)),
                  );
                }
                final campaign = _campaigns[i - 1];
                final progress = user?.campaignProgress.firstWhere(
                  (cp) => cp.campaignId == campaign.id,
                  orElse: () => CampaignProgressModel(campaignId: campaign.id, isCompleted: false, levelsCompleted: []),
                );
                final isCompleted = progress?.isCompleted ?? false;
                final levelsCompleted = progress?.levelsCompleted.length ?? 0;
                final totalLevels = campaign.levels.length;
                final req = campaign.requirement;
                final isUnlocked = req.isEmpty || (user?.campaignProgress.any((cp) => cp.campaignId == req && cp.isCompleted) ?? false);

                return _CampaignCard(
                  campaign: campaign,
                  isUnlocked: isUnlocked,
                  isCompleted: isCompleted,
                  levelsCompleted: levelsCompleted,
                  totalLevels: totalLevels,
                  accent: accent,
                  progress: progress,
                ).animate().fadeIn(delay: Duration(milliseconds: i * 80)).slideY(begin: 0.05, end: 0);
              },
            ),
    );
  }
}

class _CampaignCard extends StatefulWidget {
  final CampaignModel campaign;
  final bool isUnlocked;
  final bool isCompleted;
  final int levelsCompleted;
  final int totalLevels;
  final Color accent;
  final CampaignProgressModel? progress;
  const _CampaignCard({required this.campaign, required this.isUnlocked, required this.isCompleted, required this.levelsCompleted, required this.totalLevels, required this.accent, this.progress});

  @override
  State<_CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<_CampaignCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final pct = widget.totalLevels > 0 ? widget.levelsCompleted / widget.totalLevels : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bg800,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.isCompleted ? widget.accent.withValues(alpha: 0.4) : (widget.isUnlocked ? AppColors.border : AppColors.bg700)),
        boxShadow: widget.isCompleted ? [BoxShadow(color: widget.accent.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))] : null,
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: widget.isUnlocked ? () => setState(() => _expanded = !_expanded) : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          if (widget.isCompleted) StatusBadge(label: 'Completed', color: widget.accent),
                          if (!widget.isUnlocked) const StatusBadge(label: 'Locked', color: AppColors.textMuted),
                          if (!widget.isCompleted && widget.isUnlocked && widget.levelsCompleted > 0) StatusBadge(label: 'In Progress', color: AppColors.accentAmber),
                        ]),
                        const SizedBox(height: 8),
                        Text(widget.campaign.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: widget.isUnlocked ? AppColors.textPrimary : AppColors.textMuted)),
                        const SizedBox(height: 4),
                        Text(widget.campaign.description, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted, height: 1.4)),
                      ])),
                      const SizedBox(width: 12),
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: widget.isCompleted ? widget.accent.withValues(alpha: 0.12) : AppColors.bg700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.isCompleted ? Icons.check_circle_rounded : (widget.isUnlocked ? Icons.map_rounded : Icons.lock_rounded),
                          color: widget.isCompleted ? widget.accent : AppColors.textMuted,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  if (widget.isUnlocked) ...[
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${widget.levelsCompleted} / ${widget.totalLevels} levels', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                        Text('${(pct * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: widget.accent)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: AppColors.bg600,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.accent),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(_expanded ? 'Hide levels' : 'Show levels', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(width: 4),
                        Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Level list (expandable)
          if (widget.isUnlocked && _expanded) ...[
            Container(height: 1, color: AppColors.border),
            ...widget.campaign.levels.entries.toList().asMap().entries.map((e) {
              final idx = e.key;
              final levelKey = e.value.key;
              final level = e.value.value;
              final isDone = widget.progress?.levelsCompleted.contains(levelKey) ?? false;
              final isLast = idx == widget.campaign.levels.length - 1;

              return GestureDetector(
                onTap: () => context.go('/campaign/${widget.campaign.id}/$levelKey'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDone ? widget.accent.withValues(alpha: 0.04) : Colors.transparent,
                    border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
                    borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: isDone ? widget.accent : AppColors.bg600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: isDone
                          ? const Icon(Icons.check_rounded, size: 14, color: Colors.black)
                          : Text('${idx + 1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(level.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDone ? widget.accent : AppColors.textSecondary))),
                      Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],

          // Locked footer
          if (!widget.isUnlocked)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(children: [
                const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 14),
                const SizedBox(width: 6),
                Text('Complete ${widget.campaign.requirement} to unlock', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ]),
            ),
        ],
      ),
    );
  }
}
