import 'package:flutter/material.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/screen/login.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/userProvider.dart';
import 'dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationPasswordController =
      TextEditingController();
  bool _isRedirecting = false;

  void _handleRegister() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      _confirmationPasswordController.text,
    );

    if (!userProvider.authLoading && userProvider.errorMessage.isEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    if (user != null && !_isRedirecting) {
      _isRedirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      });
    }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: AppColors.neon),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neon),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: AppColors.neon),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neon),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.neon),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neon),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmationPasswordController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirmation Password',
                  labelStyle: const TextStyle(color: AppColors.neon),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neon),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    color: AppColors.neon,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (userProvider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            userProvider.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      NeonButton(
                        onPressed: userProvider.authLoading
                            ? null
                            : _handleRegister,
                        backgroundColor: AppColors.neon,
                        child: userProvider.authLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
