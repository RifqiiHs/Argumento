import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      setState(() => _usernameError = '* Username must be > 3 chars');
      valid = false;
    }
    if (_passwordCtrl.text.length < 8) {
      setState(() => _passwordError = '* Min 8 chars required');
      valid = false;
    }
    return valid;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService().login(_usernameCtrl.text.trim(), _passwordCtrl.text);
      await context.read<UserCubit>().loadUser();
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Access Granted.');
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Access Denied: Invalid credentials.', isError: true);
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
              const SizedBox(height: 48),
              // Border box - matches web border-5 border-green-500
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green500, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Enter credentials to access the app.',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: AppColors.zinc500,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Username field
                    ArgumentoTextField(
                      label: 'Username',
                      placeholder: 'Enter username',
                      controller: _usernameCtrl,
                      errorText: _usernameError,
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    ArgumentoTextField(
                      label: 'Password',
                      placeholder: '••••••••',
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.zinc500,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Submit button
                    AccentButton(
                      label: _isLoading ? 'Authenticating...' : 'Sign In',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                      accentColor: AppColors.green500,
                    ),
                    const SizedBox(height: 20),

                    // Links
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/sign-up'),
                            child: const Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: AppColors.zinc500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => context.go('/reset-password'),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: AppColors.zinc500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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
