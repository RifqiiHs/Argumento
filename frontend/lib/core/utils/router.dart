import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_state.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_confirm_page.dart';
import '../../features/auth/presentation/pages/verify_page.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/play/presentation/pages/daily_play_page.dart';
import '../../features/play/presentation/pages/practice_play_page.dart';
import '../../features/campaign/presentation/pages/campaign_page.dart';
import '../../features/campaign/presentation/pages/campaign_level_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/shop/presentation/pages/shop_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/history/presentation/pages/history_detail_page.dart';
import '../../features/skills_radar/presentation/pages/skills_radar_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/feedback/presentation/pages/feedback_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userCubit = context.read<UserCubit>();
    final isLoggedIn = userCubit.state.user != null;

    final protectedRoutes = [
      '/dashboard',
      '/play/daily',
      '/play/practice',
      '/campaign',
      '/shop',
      '/history',
      '/skills-radar',
      '/settings',
      '/feedbacks',
    ];

    final isProtected = protectedRoutes.any(
      (route) => state.matchedLocation.startsWith(route),
    );

    if (isProtected && !isLoggedIn) {
      return '/sign-in?message=Please+login+first';
    }

    if ((state.matchedLocation == '/sign-in' || state.matchedLocation == '/sign-up') &&
        isLoggedIn) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (ctx, _) => const HomePage()),
    GoRoute(path: '/sign-in', builder: (ctx, state) {
      final message = state.uri.queryParameters['message'];
      return SignInPage(message: message);
    }),
    GoRoute(path: '/sign-up', builder: (ctx, _) => const SignUpPage()),
    GoRoute(path: '/reset-password', builder: (ctx, _) => const ResetPasswordPage()),
    GoRoute(path: '/reset-password/:id', builder: (ctx, state) {
      return ResetPasswordConfirmPage(token: state.pathParameters['id']!);
    }),
    GoRoute(path: '/verify/:id', builder: (ctx, state) {
      return VerifyPage(token: state.pathParameters['id']!);
    }),
    GoRoute(path: '/dashboard', builder: (ctx, _) => const DashboardPage()),
    GoRoute(path: '/play/daily', builder: (ctx, _) => const DailyPlayPage()),
    GoRoute(path: '/play/practice', builder: (ctx, _) => const PracticePlayPage()),
    GoRoute(path: '/campaign', builder: (ctx, _) => const CampaignPage()),
    GoRoute(path: '/campaign/:level/:id', builder: (ctx, state) {
      return CampaignLevelPage(
        level: state.pathParameters['level']!,
        id: state.pathParameters['id']!,
      );
    }),
    GoRoute(path: '/leaderboard', builder: (ctx, _) => const LeaderboardPage()),
    GoRoute(path: '/shop', builder: (ctx, _) => const ShopPage()),
    GoRoute(path: '/history', builder: (ctx, _) => const HistoryPage()),
    GoRoute(path: '/history/:id', builder: (ctx, state) {
      return HistoryDetailPage(postId: state.pathParameters['id']!);
    }),
    GoRoute(path: '/skills-radar', builder: (ctx, _) => const SkillsRadarPage()),
    GoRoute(path: '/settings', builder: (ctx, _) => const SettingsPage()),
    GoRoute(path: '/feedbacks', builder: (ctx, _) => const FeedbackPage()),
    GoRoute(path: '/profile/:id', builder: (ctx, state) {
      return ProfilePage(userId: state.pathParameters['id']!);
    }),
  ],
);
