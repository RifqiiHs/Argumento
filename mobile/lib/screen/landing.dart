import 'package:flutter/material.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/screen/login.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Hello World"),
          NeonButton(
            label: 'Login',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            backgroundColor: AppColors.neon,
          ),
        ],
      ),
    );
  }
}
