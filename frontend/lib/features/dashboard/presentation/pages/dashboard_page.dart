import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/widgets.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/models.dart';
import '../../../shared/bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    ApiService().refreshStreak().catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = state.user;
        final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
        final accuracy = user != null && user.postsHistory.isNotEmpty
            ? ((user.postsCorrect / user.postsHistory.length) * 100).toStringAsFixed(1)
            : '0.0';
        final isShiftDone = user?.hasPlayedToday ?? false;

        return Scaffold(
          backgroundColor: AppColors.bg900,
          drawer: const AppDrawer(),
          bottomNavigationBar: const AppBottomNav(currentIndex: 0),
          body: state.isLoading
              ? LoadingOverlay(accentColor: accent)
              : CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      backgroundColor: AppColors.bg900,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      pinned: true,
                      expandedHeight: 100,
                      automaticallyImplyLeading: false,
                      leading: Builder(builder: (ctx) => IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                          child: const Icon(Icons.menu_rounded, size: 18, color: AppColors.textSecondary),
                        ),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      )),
                      actions: [
                        // Live clock
                        StreamBuilder<DateTime>(
                          stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                          builder: (_, snap) {
                            final t = snap.data ?? DateTime.now();
                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                              child: Text(
                                '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                              ),
                            );
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.fromLTRB(60, 0, 16, 16),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back,', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w400)),
                            Text(user?.username ?? '—', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                      bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // ── Stats Grid ──
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.45,
                            children: [
                              StatCard(label: 'Total EXP', value: '${user?.totalExp ?? 0}', subValue: 'experience points', accentColor: accent, icon: Icon(Icons.bolt_rounded, color: accent, size: 16)),
                              StatCard(label: 'Coins', value: '${user?.totalCoins ?? 0}', subValue: 'total earned', accentColor: accent, icon: Icon(Icons.toll_rounded, color: accent, size: 16)),
                              StatCard(label: 'Streak', value: '${user?.currentStreak ?? 0}', subValue: 'Best: ${user?.bestStreak ?? 0} days', accentColor: accent, icon: Icon(Icons.local_fire_department_rounded, color: accent, size: 16)),
                              StatCard(label: 'Accuracy', value: '$accuracy%', subValue: '${user?.postsCorrect ?? 0}/${user?.postsHistory.length ?? 0} correct', accentColor: accent, icon: Icon(Icons.gps_fixed_rounded, color: accent, size: 16)),
                            ],
                          ).animate().fadeIn(delay: 100.ms),
                          const SizedBox(height: 20),

                          // ── Daily Shift Card ──
                          _DailyCard(isShiftDone: isShiftDone, accent: accent),
                          const SizedBox(height: 12),

                          // ── Practice Card ──
                          _PracticeCard(),
                          const SizedBox(height: 12),

                          // ── Quick Actions ──
                          _QuickActions(),
                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _DailyCard extends StatelessWidget {
  final bool isShiftDone;
  final Color accent;
  const _DailyCard({required this.isShiftDone, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isShiftDone
            ? const LinearGradient(colors: [AppColors.bg700, AppColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : LinearGradient(colors: [AppColors.primaryBg, AppColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isShiftDone ? AppColors.border : accent.withValues(alpha: 0.4)),
        boxShadow: isShiftDone ? null : [BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isShiftDone ? AppColors.bg600 : accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('DAILY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: isShiftDone ? AppColors.textMuted : accent, letterSpacing: 0.8)),
                    ),
                    if (isShiftDone) ...[
                      const SizedBox(width: 6),
                      const StatusBadge(label: 'Completed', color: AppColors.success),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  isShiftDone ? 'Shift Complete' : 'Daily Shift',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: isShiftDone ? AppColors.textMuted : AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  isShiftDone ? 'Come back tomorrow for your next shift.' : 'Analyze today\'s posts and earn XP.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted, height: 1.4),
                ),
                if (!isShiftDone) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 160,
                    child: AccentButton(label: 'Start Shift', accentColor: accent, onPressed: () => context.go('/play/daily'), small: true,
                        icon: const Icon(Icons.play_arrow_rounded, size: 16, color: Colors.black)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: isShiftDone ? AppColors.bg600 : accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(isShiftDone ? Icons.check_circle_rounded : Icons.assignment_rounded, color: isShiftDone ? AppColors.textMuted : accent, size: 28),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0);
  }
}

class _PracticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/play/practice'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg800,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.infoBg),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.school_rounded, color: AppColors.info, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Practice Mode', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    const StatusBadge(label: 'Free', color: AppColors.info),
                  ]),
                  const SizedBox(height: 2),
                  Text('Train without affecting your stats', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 250.ms);
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.radar_rounded, 'Skills', '/skills-radar', AppColors.primary),
      (Icons.history_rounded, 'History', '/history', AppColors.accentAmber),
      (Icons.feedback_outlined, 'Feedback', '/feedbacks', AppColors.accentCyan),
      (Icons.map_rounded, 'Campaign', '/campaign', AppColors.accentRed),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: 'Quick Access'),
        Row(
          children: actions.map((a) => Expanded(
            child: GestureDetector(
              onTap: () => context.go(a.$3),
              child: Container(
                margin: EdgeInsets.only(right: actions.indexOf(a) < 3 ? 8.0 : 0.0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bg800,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(a.$1, color: a.$4, size: 22),
                    const SizedBox(height: 4),
                    Text(a.$2, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}
