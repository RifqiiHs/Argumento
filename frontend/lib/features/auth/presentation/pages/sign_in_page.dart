import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/widgets.dart';

class SignInPage extends StatefulWidget {
  final String? message;
  const SignInPage({super.key, this.message});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    if (widget.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ArgumentoSnackBar.show(context, widget.message!);
      });
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });
    if (_usernameCtrl.text.trim().length < 3) {
      setState(() => _usernameError = 'Minimum 3 characters');
      valid = false;
    }
    if (_passwordCtrl.text.length < 8) {
      setState(() => _passwordError = 'Minimum 8 characters');
      valid = false;
    }
    return valid;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService().login(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );
      await context.read<UserCubit>().loadUser();
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Welcome back!');
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        // Show the actual server error message
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
              const SizedBox(height: 48),
              // Logo
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDim],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.primary.glow,
                      ),
                      child: const Icon(Icons.shield_rounded,
                          color: Colors.black, size: 34),
                    ).animate().fadeIn(duration: 400.ms).scale(
                        begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 16),
                    Text('Argumento',
                            style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5))
                        .animate()
                        .fadeIn(delay: 100.ms),
                    const SizedBox(height: 4),
                    Text('Train your critical thinking',
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.textMuted))
                        .animate()
                        .fadeIn(delay: 150.ms),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bg800,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sign In',
                        style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Enter your credentials to continue',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    ArgumentoTextField(
                      label: 'Username',
                      placeholder: 'Enter your username',
                      controller: _usernameCtrl,
                      errorText: _usernameError,
                      prefixIcon: const Icon(Icons.person_outline_rounded,
                          size: 18, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ArgumentoTextField(
                      label: 'Password',
                      placeholder: '••••••••',
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      errorText: _passwordError,
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          size: 18, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/reset-password'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('Forgot password?',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AccentButton(
                      label: 'Sign In',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08, end: 0),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis, maxLines: 2),
                  GestureDetector(
                    onTap: () => context.go('/sign-up'),
                    child: Text('Sign Up',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
