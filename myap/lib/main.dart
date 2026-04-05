import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/result_screen.dart';
import 'screens/campaign_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/logout_screen.dart';

void main() {
  runApp(const ArgumentoApp());
}

/// Root application widget for Argumento.
/// Sets up named routes and shared theme styling.
class ArgumentoApp extends StatelessWidget {
  const ArgumentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argumento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FF),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.grey.shade900,
              displayColor: Colors.grey.shade900,
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/analysis': (_) => const AnalysisScreen(),
        '/result': (_) => const ResultScreen(),
        '/campaign': (_) => const CampaignScreen(),
        '/shop': (_) => const ShopScreen(),
        '/leaderboard': (_) => const LeaderboardScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/logout': (_) => const LogoutScreen(),
      },
    );
  }
}
