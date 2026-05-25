import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/widgets.dart';

// ── Reset Password Request ───────────────────────────────────
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ApiService().generateResetToken(_emailCtrl.text.trim());
      setState(() => _sent = true);
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: ArgumentoAppBar(title: 'Reset Password', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72, height: 72,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
                    child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 36),
                  ).animate().scale(begin: const Offset(0.8, 0.8)),
                  Text('Check Your Email', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('If an account exists with that email, a reset link has been sent.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.5), textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  AccentButton(label: 'Back to Sign In', onPressed: () => context.go('/sign-in')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text('Forgot Password?', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Enter your email and we\'ll send you a reset link.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 32),
                  ArgumentoTextField(
                    label: 'Email Address',
                    placeholder: 'your@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),
                  AccentButton(label: _isLoading ? 'Sending...' : 'Send Reset Link', onPressed: _isLoading ? null : _submit, isLoading: _isLoading),
                ],
              ),
      ),
    );
  }
}

// ── Reset Password Confirm ───────────────────────────────────
class ResetPasswordConfirmPage extends StatefulWidget {
  final String token;
  const ResetPasswordConfirmPage({super.key, required this.token});
  @override
  State<ResetPasswordConfirmPage> createState() => _ResetPasswordConfirmPageState();
}

class _ResetPasswordConfirmPageState extends State<ResetPasswordConfirmPage> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _showPw = false;
  String? _error;

  @override
  void dispose() { _passwordCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_passwordCtrl.text.length < 8) { setState(() => _error = 'Password must be at least 8 characters'); return; }
    if (_passwordCtrl.text != _confirmCtrl.text) { setState(() => _error = 'Passwords do not match'); return; }
    setState(() { _isLoading = true; _error = null; });
    try {
      await ApiService().resetPassword(widget.token, _passwordCtrl.text);
      if (mounted) { ArgumentoSnackBar.show(context, 'Password reset successfully.'); context.go('/sign-in'); }
    } catch (_) { setState(() => _error = 'Invalid or expired token.'); }
    finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: ArgumentoAppBar(title: 'New Password', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            ArgumentoTextField(label: 'New Password', placeholder: 'Min. 8 characters', controller: _passwordCtrl, obscureText: !_showPw,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted),
                suffixIcon: IconButton(icon: Icon(_showPw ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 18, color: AppColors.textMuted), onPressed: () => setState(() => _showPw = !_showPw))),
            const SizedBox(height: 16),
            ArgumentoTextField(label: 'Confirm New Password', placeholder: '••••••••', controller: _confirmCtrl, obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted)),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: GoogleFonts.inter(color: AppColors.error, fontSize: 12)),
            ],
            const SizedBox(height: 24),
            AccentButton(label: _isLoading ? 'Resetting...' : 'Reset Password', onPressed: _isLoading ? null : _submit, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}

// ── Verify Email ─────────────────────────────────────────────
class VerifyPage extends StatefulWidget {
  final String token;
  const VerifyPage({super.key, required this.token});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool _isLoading = true;
  bool _success = false;

  @override
  void initState() { super.initState(); _verify(); }

  Future<void> _verify() async {
    try {
      await ApiService().verifyEmail(widget.token);
      setState(() { _success = true; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _isLoading
              ? const LoadingOverlay(message: 'Verifying your email...')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 80, height: 80, margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: _success ? AppColors.primaryBg : AppColors.errorBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: (_success ? AppColors.primary : AppColors.error).withValues(alpha: 0.3)),
                      ),
                      child: Icon(_success ? Icons.verified_rounded : Icons.error_rounded, color: _success ? AppColors.primary : AppColors.error, size: 40),
                    ).animate().scale(begin: const Offset(0.8, 0.8)),
                    Text(_success ? 'Email Verified!' : 'Verification Failed', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(_success ? 'Your account is now verified. You can now play the Daily Shift.' : 'The link may have expired. Please request a new verification email.',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.5), textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    AccentButton(label: 'Go to Dashboard', onPressed: () => context.go('/dashboard')),
                  ],
                ),
        ),
      ),
    );
  }
}
