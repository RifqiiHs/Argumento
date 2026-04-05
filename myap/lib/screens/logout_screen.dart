import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

/// Logout confirmation screen for the Argumento prototype.
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Kamu telah keluar dari aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terima kasih telah mencoba prototype Argumento. Login kembali jika ingin melanjutkan latihan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Kembali ke Login',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
