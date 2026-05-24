import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/widgets.dart';

// ============ RESET PASSWORD REQUEST PAGE ============
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
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

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
      backgroundColor: AppColors.zinc950,
      appBar: ArgumentoAppBar(title: 'Reset Password', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read, color: AppColors.green500, size: 64),
                  const SizedBox(height: 24),
                  const Text(
                    'CHECK YOUR EMAIL',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'If an account exists with that email, a reset link has been sent.',
                    style: TextStyle(fontFamily: 'Courier New', color: AppColors.zinc400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AccentButton(label: 'Back to Sign In', onPressed: () => context.go('/sign-in')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  const Text(
                    'Enter your email address to receive a password reset token.',
                    style: TextStyle(fontFamily: 'Courier New', color: AppColors.zinc400, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ArgumentoTextField(
                    label: 'Email',
                    placeholder: 'your@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  AccentButton(
                    label: _isLoading ? 'Sending...' : 'Send Reset Link',
                    onPressed: _isLoading ? null : _submit,
                    isLoading: _isLoading,
                  ),
                ],
              ),
      ),
    );
  }
}

// ============ RESET PASSWORD CONFIRM PAGE ============
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
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_passwordCtrl.text.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await ApiService().resetPassword(widget.token, _passwordCtrl.text);
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Password reset successfully.');
        context.go('/sign-in');
      }
    } catch (e) {
      setState(() => _error = 'Invalid or expired token.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: ArgumentoAppBar(title: 'New Password', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            ArgumentoTextField(
              label: 'New Password',
              placeholder: '••••••••',
              controller: _passwordCtrl,
              obscureText: !_showPw,
              suffixIcon: IconButton(
                icon: Icon(_showPw ? Icons.visibility_off : Icons.visibility, color: AppColors.zinc500, size: 18),
                onPressed: () => setState(() => _showPw = !_showPw),
              ),
            ),
            const SizedBox(height: 16),
            ArgumentoTextField(
              label: 'Confirm New Password',
              placeholder: '••••••••',
              controller: _confirmCtrl,
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red, fontFamily: 'Courier New', fontSize: 12)),
            ],
            const SizedBox(height: 24),
            AccentButton(
              label: _isLoading ? 'Resetting...' : 'Reset Password',
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// ============ VERIFY EMAIL PAGE ============
class VerifyPage extends StatefulWidget {
  final String token;
  const VerifyPage({super.key, required this.token});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool _isLoading = true;
  bool _success = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    try {
      await ApiService().verifyEmail(widget.token);
      setState(() { _success = true; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Verification failed. Token may be expired.'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const LoadingOverlay(message: 'Verifying email...')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _success ? Icons.verified : Icons.error,
                      color: _success ? AppColors.green500 : Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _success ? 'EMAIL VERIFIED' : 'VERIFICATION FAILED',
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _success ? 'Your account is now verified.' : (_error ?? ''),
                      style: const TextStyle(fontFamily: 'Courier New', color: AppColors.zinc400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AccentButton(
                      label: 'Go to Dashboard',
                      onPressed: () => context.go('/dashboard'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
