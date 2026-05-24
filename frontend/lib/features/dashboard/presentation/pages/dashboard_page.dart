import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    // Refresh streak on dashboard load
    ApiService().refreshStreak().catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = state.user;
        final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
        final accuracy = user != null && user.postsHistory.isNotEmpty
            ? ((user.postsCorrect / user.postsHistory.length) * 100).toStringAsFixed(1)
            : '0.0';
        final isShiftDone = user?.hasPlayedToday ?? false;

        return Scaffold(
          backgroundColor: AppColors.zinc950,
          appBar: _DashboardAppBar(user: user, accentColor: accentColor),
          bottomNavigationBar: const AppBottomNav(currentIndex: 0),
          body: state.isLoading
              ? LoadingOverlay(accentColor: accentColor)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Grid
                      _StatsGrid(user: user, accuracy: accuracy, accentColor: accentColor),
                      const SizedBox(height: 16),

                      // Daily Assignment Card
                      _DailyCard(isShiftDone: isShiftDone, accentColor: accentColor),
                      const SizedBox(height: 12),

                      // Practice Card
                      _PracticeCard(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

// ---- App Bar ----
class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;
  final Color accentColor;

  const _DashboardAppBar({required this.user, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: AppColors.zinc950,
        border: Border(bottom: BorderSide(color: AppColors.zinc800)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield, size: 16, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      'LOGGED IN AS',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Text(
                  (user?.username ?? '...').toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            StreamBuilder<DateTime>(
              stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
              builder: (_, snap) {
                final t = snap.data ?? DateTime.now();
                final time =
                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
                return Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.zinc400,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

// ---- Stats Grid ----
class _StatsGrid extends StatelessWidget {
  final UserModel? user;
  final String accuracy;
  final Color accentColor;

  const _StatsGrid({required this.user, required this.accuracy, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          label: 'Total Exp',
          value: (user?.totalExp ?? 0).toString(),
          subValue: 'XP Points Accumulated',
          accentColor: accentColor,
          icon: Icon(Icons.bar_chart, color: accentColor, size: 18),
        ),
        StatCard(
          label: 'Total Coins',
          value: (user?.totalCoins ?? 0).toString(),
          subValue: 'Coins Accumulated',
          accentColor: accentColor,
          icon: Icon(Icons.monetization_on, color: accentColor, size: 18),
        ),
        StatCard(
          label: 'Streak',
          value: '${user?.currentStreak ?? 0}',
          subValue: 'Best: ${user?.bestStreak ?? 0}',
          accentColor: accentColor,
          icon: Icon(Icons.local_fire_department, color: accentColor, size: 18),
        ),
        StatCard(
          label: 'Performance',
          value: '$accuracy%',
          subValue: '${user?.postsCorrect ?? 0} / ${user?.postsHistory.length ?? 0}',
          accentColor: accentColor,
          icon: Icon(Icons.track_changes, color: accentColor, size: 18),
        ),
      ],
    );
  }
}

// ---- Daily Card ----
class _DailyCard extends StatelessWidget {
  final bool isShiftDone;
  final Color accentColor;

  const _DailyCard({required this.isShiftDone, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zinc950.withOpacity(0.5),
        border: Border(
          left: BorderSide(
            color: isShiftDone ? AppColors.zinc700 : accentColor,
            width: 4,
          ),
          top: BorderSide(color: isShiftDone ? AppColors.zinc700 : accentColor),
          right: BorderSide(color: isShiftDone ? AppColors.zinc700 : accentColor),
          bottom: BorderSide(color: isShiftDone ? AppColors.zinc700 : accentColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAILY ASSIGNMENT',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isShiftDone ? AppColors.zinc500 : accentColor,
                  letterSpacing: 2,
                ),
              ),
              isShiftDone
                  ? const Icon(Icons.check_circle, color: AppColors.zinc500, size: 18)
                  : Icon(Icons.play_arrow, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          if (isShiftDone) ...[
            const Text(
              'Shift Complete',
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.zinc400,
              ),
            ),
            const Text(
              'Come back tomorrow.',
              style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc600),
            ),
          ] else ...[
            const Text(
              'Pending tasks available.',
              style: TextStyle(fontFamily: 'Courier New', fontSize: 13, color: AppColors.zinc400),
            ),
            const SizedBox(height: 12),
            AccentButton(
              label: 'Initiate Shift',
              accentColor: accentColor,
              onPressed: () => context.go('/play/daily'),
            ),
          ],
        ],
      ),
    );
  }
}

// ---- Practice Card ----
class _PracticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        border: Border(
          left: const BorderSide(color: Colors.blue, width: 4),
          top: BorderSide(color: Colors.blue.withOpacity(0.5)),
          right: BorderSide(color: Colors.blue.withOpacity(0.5)),
          bottom: BorderSide(color: Colors.blue.withOpacity(0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DEMO MODE',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 2,
                ),
              ),
              Icon(Icons.shield_outlined, color: Colors.blue.shade300, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Train without pressure.',
            style: TextStyle(fontFamily: 'Courier New', fontSize: 13, color: Colors.lightBlueAccent),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/play/practice'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'INITIATE SHIFT',
                style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
