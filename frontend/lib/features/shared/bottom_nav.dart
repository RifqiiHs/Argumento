import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_state.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.getAccentColor(
      context.watch<UserCubit>().state.user?.activeTheme ?? 'theme_green',
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg800,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, currentIndex: currentIndex, accent: accent, route: '/dashboard'),
              _NavItem(icon: Icons.map_rounded, label: 'Campaign', index: 1, currentIndex: currentIndex, accent: accent, route: '/campaign'),
              _NavItem(icon: Icons.storefront_rounded, label: 'Shop', index: 2, currentIndex: currentIndex, accent: accent, route: '/shop'),
              _NavItem(icon: Icons.leaderboard_rounded, label: 'Ranking', index: 3, currentIndex: currentIndex, accent: accent, route: '/leaderboard'),
              _NavItem(icon: Icons.person_rounded, label: 'Settings', index: 4, currentIndex: currentIndex, accent: accent, route: '/settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Color accent;
  final String route;

  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, required this.accent, required this.route});

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => context.go(route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? accent.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: isActive ? accent : AppColors.textMuted),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.getAccentColor(
      context.watch<UserCubit>().state.user?.activeTheme ?? 'theme_green',
    );
    final user = context.watch<UserCubit>().state.user;

    return Drawer(
      backgroundColor: AppColors.bg800,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Text(
                        (user?.username ?? 'A').substring(0, 1).toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.username ?? 'Argumento', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text('${user?.totalExp ?? 0} XP', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _DrawerItem(icon: Icons.radar_rounded, label: 'Skills Radar', onTap: () { Navigator.pop(context); context.go('/skills-radar'); }),
            _DrawerItem(icon: Icons.history_rounded, label: 'Post History', onTap: () { Navigator.pop(context); context.go('/history'); }),
            _DrawerItem(icon: Icons.feedback_outlined, label: 'Feedback', onTap: () { Navigator.pop(context); context.go('/feedbacks'); }),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Divider(color: AppColors.border)),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              color: AppColors.error,
              onTap: () async {
                Navigator.pop(context);
                await context.read<UserCubit>().logout();
                if (context.mounted) context.go('/sign-in');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: c, size: 18),
      ),
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: c)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
