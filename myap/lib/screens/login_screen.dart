import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

/// Login screen prototype for Argumento.
/// Uses dummy inputs and navigates to dashboard on tap.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text('Argumento', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 12),
              const Text(
                'Pelajari cara mengenali berita asli dan hoax dengan cara yang menyenangkan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                        label: 'Login',
                        onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Create account',
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tidak perlu backend. Ini hanya prototype UI.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
