import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isLoading = false;
  Map<String, String?> _errors = {};

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final errors = <String, String?>{};
    if (_usernameCtrl.text.trim().length < 3) {
      errors['username'] = 'Minimum 3 characters';
    }
    if (!_emailCtrl.text.contains('@') || !_emailCtrl.text.contains('.')) {
      errors['email'] = 'Enter a valid email address';
    }
    if (_passwordCtrl.text.length < 8) {
      errors['password'] = 'Minimum 8 characters';
    }
    if (_confirmCtrl.text != _passwordCtrl.text) {
      errors['confirm'] = 'Passwords do not match';
    }
    setState(() => _errors = errors);
    return errors.isEmpty;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService().register(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
        _emailCtrl.text.trim(),
      );
      await context.read<UserCubit>().loadUser();
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Account created successfully!');
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        ArgumentoSnackBar.show(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Back button
              GestureDetector(
                onTap: () => context.go('/sign-in'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bg700,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 28),
              Text('Create Account',
                  style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('Start your critical thinking journey',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bg800,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ArgumentoTextField(
                      label: 'Username',
                      placeholder: 'Choose a username',
                      controller: _usernameCtrl,
                      errorText: _errors['username'],
                      prefixIcon: const Icon(Icons.person_outline_rounded,
                          size: 18, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ArgumentoTextField(
                      label: 'Email',
                      placeholder: 'your@email.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _errors['email'],
                      prefixIcon: const Icon(Icons.email_outlined,
                          size: 18, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ArgumentoTextField(
                      label: 'Password',
                      placeholder: 'Min. 8 characters',
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      errorText: _errors['password'],
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          size: 18, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ArgumentoTextField(
                      label: 'Confirm Password',
                      placeholder: 'Re-enter password',
                      controller: _confirmCtrl,
                      obscureText: !_showConfirm,
                      errorText: _errors['confirm'],
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          size: 18, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirm
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AccentButton(
                      label: 'Create Account',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis, maxLines: 2),
                  GestureDetector(
                    onTap: () => context.go('/sign-in'),
                    child: Text('Sign In',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
