import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    } catch (e) {
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
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to delete account.', isError: true);
      setState(() => _isDeleting = false);
    }
  }

  Future<void> _logout() async {
    await context.read<UserCubit>().logout();
    if (mounted) context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: ArgumentoAppBar(title: 'Settings'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _SectionTitle(title: 'Account'),
            _InfoCard(
              children: [
                _InfoRow(label: 'Username', value: user?.username ?? '-'),
                _InfoRow(label: 'Email', value: user?.email ?? '-'),
                _InfoRow(label: 'Verified', value: user?.isVerified == true ? '✓ Yes' : '✗ No'),
                _InfoRow(label: 'Member Since', value: user?.createdAt?.year.toString() ?? '-'),
              ],
            ),

            const SizedBox(height: 20),

            // Verification section
            if (user?.isVerified == false) ...[
              _SectionTitle(title: 'Verification'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.05),
                  border: Border.all(color: Colors.yellow.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.yellow, size: 18),
                        SizedBox(width: 8),
                        Text('Email not verified', style: TextStyle(fontFamily: 'Courier New', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.yellow)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Verify your email to unlock all features including the Daily Shift.',
                      style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc400),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isResending ? null : _resendVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.withOpacity(0.15),
                        foregroundColor: Colors.yellow,
                        side: const BorderSide(color: Colors.yellow),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        _isResending ? 'Sending...' : 'Resend Verification Email',
                        style: const TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Stats Section
            _SectionTitle(title: 'Your Stats'),
            _InfoCard(
              children: [
                _InfoRow(label: 'Total EXP', value: '${user?.totalExp ?? 0}'),
                _InfoRow(label: 'Total Coins', value: '${user?.totalCoins ?? 0}'),
                _InfoRow(label: 'Current Streak', value: '${user?.currentStreak ?? 0} days'),
                _InfoRow(label: 'Best Streak', value: '${user?.bestStreak ?? 0} days'),
                _InfoRow(label: 'Posts Reviewed', value: '${user?.postsHistory.length ?? 0}'),
                _InfoRow(label: 'Accuracy', value: user != null && user.postsHistory.isNotEmpty
                    ? '${((user.postsCorrect / user.postsHistory.length) * 100).toStringAsFixed(1)}%'
                    : 'N/A'),
              ],
            ),

            const SizedBox(height: 20),

            // Quick links
            _SectionTitle(title: 'Navigation'),
            _LinkCard(
              items: [
                _LinkItem(icon: Icons.radar, label: 'Skills Radar', onTap: () => context.go('/skills-radar')),
                _LinkItem(icon: Icons.history, label: 'Post Log', onTap: () => context.go('/history')),
                _LinkItem(icon: Icons.message_outlined, label: 'Submit Feedback', onTap: () => context.go('/feedbacks')),
                _LinkItem(icon: Icons.person_outline, label: 'My Profile', onTap: () => context.go('/profile/${user?.id}')),
              ],
            ),

            const SizedBox(height: 20),

            // Sign out
            _SectionTitle(title: 'Session'),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('SIGN OUT', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 2)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.zinc400,
                  side: const BorderSide(color: AppColors.zinc700),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Danger Zone
            _SectionTitle(title: 'Danger Zone', color: Colors.red),
            if (!_showDeleteConfirm) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() => _showDeleteConfirm = true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('DELETE ACCOUNT', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('WARNING: This action is irreversible. All your data, stats, and progress will be permanently deleted.', style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: Colors.red, height: 1.4)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isDeleting ? null : _deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(_isDeleting ? '...' : 'CONFIRM DELETE', style: const TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _showDeleteConfirm = false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.zinc400,
                              side: const BorderSide(color: AppColors.zinc700),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('CANCEL', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color? color;
  const _SectionTitle({required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Courier New', fontSize: 10, fontWeight: FontWeight.bold, color: color ?? AppColors.zinc500, letterSpacing: 2)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.zinc900))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 1)),
          Text(value, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final List<_LinkItem> items;
  const _LinkCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
      child: Column(children: items),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.zinc900))),
        child: Row(
          children: [
            Icon(icon, color: AppColors.zinc400, size: 18),
            const SizedBox(width: 12),
            Expanded(child: Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, letterSpacing: 1))),
            const Icon(Icons.chevron_right, color: AppColors.zinc600, size: 18),
          ],
        ),
      ),
    );
  }
}
