import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/screen/campaign.dart';
import 'package:mobile/screen/dashboard.dart';
import 'package:mobile/screen/game.dart';
import 'package:mobile/screen/landing.dart';
import 'package:mobile/screen/leaderboard.dart';
import 'package:mobile/screen/login.dart';
import 'package:mobile/screen/register.dart';
import 'package:mobile/screen/settings.dart';
import 'package:mobile/screen/shop.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/userProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Argumento',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: AppColors.neon,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.neon,
            secondary: Colors.white,
          ),
          textTheme: GoogleFonts.firaCodeTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.grey[300],
              displayColor: Colors.white,
            ),
          ),
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/shop': (_) => const ShopScreen(),
          '/leaderboard': (_) => const LeaderboardScreen(),
          '/game': (_) => const GameScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/campaign': (_) => const CampaignScreen(),
        },
        home: LandingScreen(),
      ),
    );
  }
}
