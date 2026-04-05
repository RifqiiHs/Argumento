import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

/// Signup screen prototype for Argumento.
/// Collects dummy user details and navigates to dashboard.
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo,
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'Sign Up',
                      onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: 'Back to login',
                      onPressed: () => Navigator.pop(context),
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
