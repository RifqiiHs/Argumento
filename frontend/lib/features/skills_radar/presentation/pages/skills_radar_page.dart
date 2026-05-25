import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

class SkillsRadarPage extends StatelessWidget {
  const SkillsRadarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final stats = user?.stats ?? [];

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary),
          ),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Skills Radar', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visualize your performance across all content categories.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.5)),
            const SizedBox(height: 20),

            // Radar Chart Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bg800,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: stats.isEmpty
                  ? SizedBox(
                      height: 220,
                      child: EmptyState(
                        title: 'No data yet',
                        subtitle: 'Complete a daily shift to populate your radar.',
                        icon: Icon(Icons.radar_rounded, size: 40, color: AppColors.textMuted),
                      ),
                    )
                  : Column(
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.radar_rounded, color: accent, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Text('Performance Radar', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 240,
                          child: RadarChart(
                            RadarChartData(
                              dataSets: [
                                RadarDataSet(
                                  fillColor: accent.withValues(alpha: 0.12),
                                  borderColor: accent,
                                  borderWidth: 2,
                                  entryRadius: 5,
                                  dataEntries: stats.map((s) {
                                    final pct = s.total > 0 ? (s.correct / s.total) * 100 : 0.0;
                                    return RadarEntry(value: pct);
                                  }).toList(),
                                ),
                              ],
                              radarBackgroundColor: Colors.transparent,
                              borderData: FlBorderData(show: false),
                              radarBorderData: BorderSide(color: AppColors.border, width: 1),
                              gridBorderData: BorderSide(color: AppColors.bg600, width: 1),
                              tickCount: 4,
                              tickBorderData: const BorderSide(color: Colors.transparent),
                              ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                              getTitle: (index, angle) => RadarChartTitle(
                                text: index < stats.length ? stats[index].name.split(' ').first : '',
                                angle: angle,
                              ),
                              titleTextStyle: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                              titlePositionPercentageOffset: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),

            // Per-category breakdown
            SectionLabel(text: 'Category Breakdown'),
            const SizedBox(height: 8),
            if (stats.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.bg800, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Text('Play a shift to see your breakdown.', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
              )
            else
              ...stats.asMap().entries.map((e) => _StatBar(stat: e.value, accent: accent)
                  .animate().fadeIn(delay: Duration(milliseconds: 150 + e.key * 60)).slideX(begin: -0.05, end: 0)),

            const SizedBox(height: 20),

            // Overall
            _OverallCard(user: user, accent: accent).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final StatModel stat;
  final Color accent;
  const _StatBar({required this.stat, required this.accent});

  @override
  Widget build(BuildContext context) {
    final pct = stat.total > 0 ? stat.correct / stat.total : 0.0;
    final pctStr = '${(pct * 100).toStringAsFixed(0)}%';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Row(children: [
                Text('${stat.correct}/${stat.total}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(width: 8),
                Text(pctStr, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: accent)),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.bg600,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  final UserModel? user;
  final Color accent;
  const _OverallCard({required this.user, required this.accent});

  @override
  Widget build(BuildContext context) {
    final total = user?.postsHistory.length ?? 0;
    final correct = user?.postsCorrect ?? 0;
    final accuracy = total > 0 ? ((correct / total) * 100).toStringAsFixed(1) : '0.0';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primaryBg, AppColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overall Performance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              _OverallItem(label: 'Total Posts', value: '$total', accent: accent),
              Container(width: 1, height: 40, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 16)),
              _OverallItem(label: 'Correct', value: '$correct', accent: accent),
              Container(width: 1, height: 40, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 16)),
              _OverallItem(label: 'Accuracy', value: '$accuracy%', accent: accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallItem extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  const _OverallItem({required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: accent)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted), textAlign: TextAlign.center),
      ]),
    );
  }
}
