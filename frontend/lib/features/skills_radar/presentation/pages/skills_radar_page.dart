import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

class SkillsRadarPage extends StatelessWidget {
  const SkillsRadarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final stats = user?.stats ?? [];

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.zinc400), onPressed: () => context.go('/dashboard')),
        title: const Text('SKILL RADAR', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Performance breakdown across all content categories.',
              style: TextStyle(fontFamily: 'Courier New', fontSize: 13, color: AppColors.zinc400),
            ),
            const SizedBox(height: 24),

            // Radar Chart
            if (stats.isEmpty) ...[
              Container(
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
                child: const EmptyState(
                  title: 'No data yet',
                  subtitle: 'Complete a daily shift to populate the radar.',
                ),
              ),
            ] else ...[
              _RadarChartWidget(stats: stats, accentColor: accentColor),
            ],

            const SizedBox(height: 24),

            // Per-category breakdown
            const Text('CATEGORY BREAKDOWN', style: TextStyle(fontFamily: 'Courier New', fontSize: 11, color: AppColors.zinc500, letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (stats.isEmpty)
              const Text('Play a shift to see your breakdown.', style: TextStyle(fontFamily: 'Courier New', color: AppColors.zinc600, fontSize: 12))
            else
              ...stats.map((stat) => _StatBar(stat: stat, accentColor: accentColor)),

            const SizedBox(height: 24),

            // Overall stats
            _OverallStats(user: user, accentColor: accentColor),
          ],
        ),
      ),
    );
  }
}

class _RadarChartWidget extends StatelessWidget {
  final List<StatModel> stats;
  final Color accentColor;

  const _RadarChartWidget({required this.stats, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final dataEntries = stats.map((s) {
      final pct = s.total > 0 ? (s.correct / s.total) * 100 : 0.0;
      return RadarEntry(value: pct);
    }).toList();

    final tickLabels = stats.map((s) => s.name.replaceAll(' ', '\n')).toList();

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.zinc800),
        color: AppColors.zinc900.withOpacity(0.2),
      ),
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: accentColor.withOpacity(0.15),
              borderColor: accentColor,
              borderWidth: 2,
              entryRadius: 4,
              dataEntries: dataEntries,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: BorderSide(color: AppColors.zinc700, width: 1),
          gridBorderData: BorderSide(color: AppColors.zinc800, width: 1),
          tickCount: 4,
          tickBorderData: BorderSide(color: AppColors.zinc700, width: 1),
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: index < tickLabels.length ? tickLabels[index] : '',
              angle: angle,
            );
          },
          titleTextStyle: const TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc400),
          titlePositionPercentageOffset: 0.15,
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final StatModel stat;
  final Color accentColor;

  const _StatBar({required this.stat, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final pct = stat.total > 0 ? stat.correct / stat.total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: accentColor, width: 3)),
        color: AppColors.zinc900.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.name.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
              Text(
                '${stat.correct} / ${stat.total}',
                style: TextStyle(fontFamily: 'Courier New', fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.zinc800,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            minHeight: 6,
          ),
          const SizedBox(height: 4),
          Text(
            '${(pct * 100).toStringAsFixed(1)}% accuracy',
            style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500),
          ),
        ],
      ),
    );
  }
}

class _OverallStats extends StatelessWidget {
  final UserModel? user;
  final Color accentColor;

  const _OverallStats({required this.user, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final total = user?.postsHistory.length ?? 0;
    final correct = user?.postsCorrect ?? 0;
    final accuracy = total > 0 ? ((correct / total) * 100).toStringAsFixed(1) : '0.0';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('OVERALL PERFORMANCE', style: TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _OverallItem(label: 'Total Posts', value: '$total', accentColor: accentColor)),
              Expanded(child: _OverallItem(label: 'Correct', value: '$correct', accentColor: accentColor)),
              Expanded(child: _OverallItem(label: 'Accuracy', value: '$accuracy%', accentColor: accentColor)),
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
  final Color accentColor;

  const _OverallItem({required this.label, required this.value, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontFamily: 'Courier New', fontSize: 24, fontWeight: FontWeight.w900, color: accentColor)),
        Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc500, letterSpacing: 1)),
      ],
    );
  }
}
