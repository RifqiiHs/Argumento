import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      errors['username'] = '* Username must be > 3 chars';
    }
    if (!_emailCtrl.text.contains('@')) {
      errors['email'] = '* Valid email required';
    }
    if (_passwordCtrl.text.length < 8) {
      errors['password'] = '* Min 8 chars required';
    }
    if (_confirmCtrl.text != _passwordCtrl.text) {
      errors['confirm'] = '* Passwords do not match';
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
        ArgumentoSnackBar.show(context, 'Account created successfully.');
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Registration failed. Try again.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green500, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Initialize your profile to start tracking your progress.',
                      style: TextStyle(fontFamily: 'Courier New', fontSize: 13, color: AppColors.zinc500),
                    ),
                    const SizedBox(height: 28),

                    ArgumentoTextField(
                      label: 'Username',
                      placeholder: 'Enter username',
                      controller: _usernameCtrl,
                      errorText: _errors['username'],
                    ),
                    const SizedBox(height: 20),
                    ArgumentoTextField(
                      label: 'Email',
                      placeholder: 'Enter email',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _errors['email'],
                    ),
                    const SizedBox(height: 20),
                    ArgumentoTextField(
                      label: 'Password',
                      placeholder: '••••••••',
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      errorText: _errors['password'],
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.zinc500, size: 18),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ArgumentoTextField(
                      label: 'Confirm Password',
                      placeholder: '••••••••',
                      controller: _confirmCtrl,
                      obscureText: !_showConfirm,
                      errorText: _errors['confirm'],
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.zinc500, size: 18),
                        onPressed: () => setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                    const SizedBox(height: 28),

                    AccentButton(
                      label: _isLoading ? 'Registering...' : 'Sign Up',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/sign-in'),
                        child: const Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 13,
                            color: AppColors.zinc500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
