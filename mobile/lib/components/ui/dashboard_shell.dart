import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';

class DashboardShell extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  const DashboardShell({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.black,
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => _navigate(context, '/dashboard'),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Shop'),
                onTap: () => _navigate(context, '/shop'),
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard),
                title: const Text('Leaderboard'),
                onTap: () => _navigate(context, '/leaderboard'),
              ),
              ListTile(
                leading: const Icon(Icons.computer),
                title: const Text('Game'),
                onTap: () => _navigate(context, '/game'),
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Campaign'),
                onTap: () => _navigate(context, '/campaign'),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => _navigate(context, '/settings'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  final userProvider = context.read<UserProvider>();
                  await userProvider.logOut();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
