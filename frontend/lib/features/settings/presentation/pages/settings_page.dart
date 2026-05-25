import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showDeleteConfirm = false;
  bool _isDeleting = false;
  bool _isResending = false;

  Future<void> _resendVerification() async {
    final user = context.read<UserCubit>().state.user;
    if (user == null) return;
    setState(() => _isResending = true);
    try {
      await ApiService().sendVerifyEmail(user.email);
      if (mounted) ArgumentoSnackBar.show(context, 'Verification email sent!');
    } catch (_) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to send email.', isError: true);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    try {
      await ApiService().deleteAccount();
      await context.read<UserCubit>().logout();
      if (mounted) context.go('/sign-in');
    } catch (_) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to delete account.', isError: true);
      setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: ArgumentoAppBar(title: 'Settings'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primaryBg, AppColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [accent, accent.withValues(alpha: 0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(
                      (user?.username ?? 'A').substring(0, 1).toUpperCase(),
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
                    )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user?.username ?? '—', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text(user?.email ?? '—', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                    const SizedBox(height: 6),
                    Row(children: [
                      user?.isVerified == true
                          ? const StatusBadge(label: '✓ Verified', color: AppColors.success)
                          : const StatusBadge(label: 'Not verified', color: AppColors.warning),
                    ]),
                  ])),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            // Verification warning
            if (user?.isVerified == false) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 18),
                      const SizedBox(width: 8),
                      Text('Email not verified', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.warning)),
                    ]),
                    const SizedBox(height: 6),
                    Text('Verify your email to unlock the Daily Shift.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _isResending ? null : _resendVerification,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text(_isResending ? 'Sending...' : 'Resend Verification Email', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Stats
            SectionLabel(text: 'Your Stats'),
            InfoCard(children: [
              InfoRow(label: 'Total EXP', value: '${user?.totalExp ?? 0} XP', valueColor: accent),
              InfoRow(label: 'Total Coins', value: '${user?.totalCoins ?? 0}'),
              InfoRow(label: 'Current Streak', value: '${user?.currentStreak ?? 0} days'),
              InfoRow(label: 'Best Streak', value: '${user?.bestStreak ?? 0} days'),
              InfoRow(label: 'Posts Reviewed', value: '${user?.postsHistory.length ?? 0}'),
              InfoRow(
                label: 'Accuracy',
                value: user != null && user.postsHistory.isNotEmpty ? '${((user.postsCorrect / user.postsHistory.length) * 100).toStringAsFixed(1)}%' : 'N/A',
                isLast: true,
              ),
            ]),
            const SizedBox(height: 20),

            // Navigation
            SectionLabel(text: 'More'),
            InfoCard(children: [
              _NavLink(icon: Icons.radar_rounded, label: 'Skills Radar', color: AppColors.primary, onTap: () => context.go('/skills-radar')),
              _NavLink(icon: Icons.history_rounded, label: 'Post History', color: AppColors.accentAmber, onTap: () => context.go('/history')),
              _NavLink(icon: Icons.feedback_outlined, label: 'Submit Feedback', color: AppColors.accentCyan, onTap: () => context.go('/feedbacks')),
              _NavLink(icon: Icons.person_rounded, label: 'My Profile', color: AppColors.accentRed, onTap: () => context.go('/profile/${user?.id}'), isLast: true),
            ]),
            const SizedBox(height: 20),

            // Sign out
            ArgumentoOutlinedButton(
              label: 'Sign Out',
              icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.textSecondary),
              onPressed: () async { await context.read<UserCubit>().logout(); if (mounted) context.go('/sign-in'); },
            ),
            const SizedBox(height: 20),

            // Danger zone
            SectionLabel(text: 'Danger Zone'),
            if (!_showDeleteConfirm)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showDeleteConfirm = true),
                  icon: const Icon(Icons.delete_forever_rounded, size: 16, color: AppColors.error),
                  label: Text('Delete Account', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error, width: 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withValues(alpha: 0.3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('⚠️ This is permanent', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                    const SizedBox(height: 6),
                    Text('All your data, stats, and progress will be permanently deleted. This cannot be undone.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, height: 1.5)),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: SizedBox(height: 44, child: ElevatedButton(
                        onPressed: _isDeleting ? null : _deleteAccount,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text(_isDeleting ? 'Deleting...' : 'Yes, Delete', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13)),
                      ))),
                      const SizedBox(width: 10),
                      Expanded(child: SizedBox(height: 44, child: OutlinedButton(
                        onPressed: () => setState(() => _showDeleteConfirm = false),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary)),
                      ))),
                    ]),
                  ],
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLast;
  const _NavLink({required this.icon, required this.label, required this.color, required this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary))),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
        ]),
      ),
    );
  }
}
