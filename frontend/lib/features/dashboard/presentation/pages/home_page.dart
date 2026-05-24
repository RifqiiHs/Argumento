import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 48),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.zinc800)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Text(
                    'ARGUMENTO',
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.zinc500,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Headline
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                        height: 0.95,
                      ),
                      children: [
                        TextSpan(text: 'MASTER\nCRITICAL\n'),
                        TextSpan(
                          text: 'THINKING',
                          style: TextStyle(color: AppColors.green500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'In a world drowning in misinformation, your mind is your greatest weapon. Train to instantly detect logical fallacies, expose media manipulation, and see through AI-generated deception.',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 14,
                      color: AppColors.zinc400,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Live Example Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.zinc900.withOpacity(0.3),
                      border: Border.all(color: AppColors.zinc800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'LIVE EXAMPLE',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 10,
                                color: AppColors.zinc500,
                                letterSpacing: 2,
                              ),
                            ),
                            const Text(
                              'ANALYSIS MODE',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 10,
                                color: AppColors.green500,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.zinc900,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 8, width: 80, color: AppColors.zinc800),
                              const SizedBox(height: 8),
                              Container(height: 12, width: double.infinity, color: Colors.white.withOpacity(0.1)),
                              const SizedBox(height: 6),
                              Container(height: 12, width: 200, color: Colors.white.withOpacity(0.1)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                color: Colors.red.withOpacity(0.2),
                                child: const Icon(Icons.shield, color: Colors.red, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'REASONING FLAW',
                                    style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    'Ad Hominem • Attack on person',
                                    style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 11,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AccentButton(
                    label: 'Get Started',
                    accentColor: AppColors.green500,
                    onPressed: () => context.go('/sign-up'),
                    icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 18),
                  ),
                  const SizedBox(height: 12),
                  ArgumentoOutlinedButton(
                    label: 'Sign In',
                    onPressed: () => context.go('/sign-in'),
                    borderColor: AppColors.zinc700,
                    textColor: AppColors.zinc400,
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "HOW YOU'LL TRAIN",
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Three powerful modes to transform you from information consumer to critical analyst',
                    style: TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 13,
                      color: AppColors.zinc400,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    height: 3,
                    width: 48,
                    color: AppColors.green500,
                  ),
                  const SizedBox(height: 8),
                  _FeatureCard(
                    icon: Icons.shield_outlined,
                    title: 'Daily Defense',
                    description:
                        'Sharpen your skills with real-world content every day. Hunt down fallacies, expose clickbait, and filter the noise. Build your streak, level up.',
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    icon: Icons.psychology,
                    title: 'Campaign Mode',
                    description:
                        'Journey from novice to expert through curated challenges. Start with classic fallacies like Ad Hominem, then tackle modern threats like AI hallucinations.',
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    icon: Icons.radar,
                    title: 'Skill Radar',
                    description:
                        'See your cognitive strengths and blind spots visualized. Our system analyzes your performance across fallacy types and reasoning patterns.',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.zinc900.withOpacity(0.2),
        border: Border.all(color: AppColors.zinc800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              border: Border.all(color: AppColors.zinc800),
            ),
            child: Icon(icon, color: AppColors.green500, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 13,
              color: AppColors.zinc400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
