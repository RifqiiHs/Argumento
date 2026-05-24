import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_state.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppTheme.getAccentColor(
      context.watch<UserCubit>().state.user?.activeTheme ?? 'theme_green',
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.zinc950,
        border: Border(top: BorderSide(color: AppColors.zinc800)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/campaign'); break;
            case 2: context.go('/shop'); break;
            case 3: context.go('/leaderboard'); break;
            case 4: context.go('/settings'); break;
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: accentColor,
        unselectedItemColor: AppColors.zinc500,
        selectedLabelStyle: const TextStyle(fontFamily: 'Courier New', fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Courier New', fontSize: 9),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined, size: 22), label: 'DASH'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined, size: 22), label: 'CAMPAIGN'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined, size: 22), label: 'SHOP'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined, size: 22), label: 'RANKING'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: 22), label: 'SETTINGS'),
        ],
      ),
    );
  }
}

// Drawer for secondary links (User Stats, History, Feedback)
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppTheme.getAccentColor(
      context.watch<UserCubit>().state.user?.activeTheme ?? 'theme_green',
    );

    return Drawer(
      backgroundColor: AppColors.zinc950,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.zinc800))),
              child: const Text(
                'ARGUMENTO',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _DrawerItem(icon: Icons.radar, label: 'User Stats', onTap: () { Navigator.pop(context); context.go('/skills-radar'); }),
            _DrawerItem(icon: Icons.history, label: 'Post Log', onTap: () { Navigator.pop(context); context.go('/history'); }),
            _DrawerItem(icon: Icons.message_outlined, label: 'Feedback', onTap: () { Navigator.pop(context); context.go('/feedbacks'); }),
            const Divider(color: AppColors.zinc800),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Log Out',
              color: Colors.red,
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
    final c = color ?? AppColors.zinc400;
    return ListTile(
      leading: Icon(icon, color: c, size: 20),
      title: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Courier New',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: c,
          letterSpacing: 1.5,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
