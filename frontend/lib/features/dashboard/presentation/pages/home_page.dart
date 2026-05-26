import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text('ARGUMENTO',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),

                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Master\nCritical\n',
                            style: GoogleFonts.inter(
                                fontSize: 46,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                height: 1.05,
                                letterSpacing: -1.5)),
                        TextSpan(
                            text: 'Thinking',
                            style: GoogleFonts.inter(
                                fontSize: 46,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                height: 1.05,
                                letterSpacing: -1.5)),
                      ]),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 20),

                    Text(
                      'In a world drowning in misinformation, your mind is your greatest weapon. Train to detect logical fallacies, expose manipulation, and see through deception.',
                      style: GoogleFonts.inter(
                          fontSize: 15, color: AppColors.textMuted, height: 1.6),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),

                    // Demo post card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bg800,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row — FIX: Column inside Expanded to prevent overflow
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: AppColors.bg600,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.person_rounded,
                                    size: 16, color: AppColors.textMuted),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PoliticsWatch',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary)),
                                    Text('2 min ago',
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.errorBg,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: AppColors.error
                                            .withValues(alpha: 0.3))),
                                child: Text('SLOP',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.error)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"Why trust Senator Reyes on climate policy? She drives an SUV! Her hypocrisy invalidates everything she says."',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 12),
                          // FIX: Expanded + overflow ellipsis inside Row
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.errorBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        AppColors.error.withValues(alpha: 0.2))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: AppColors.error, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Ad Hominem — attacking the person, not the argument',
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: AppColors.error),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 32),

                    AccentButton(
                      label: 'Get Started',
                      onPressed: () => context.go('/sign-up'),
                      icon: const Icon(Icons.arrow_forward_rounded,
                          size: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    ArgumentoOutlinedButton(
                      label: 'Sign In',
                      onPressed: () => context.go('/sign-in'),
                      textColor: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              // Features section
              Container(
                color: AppColors.bg800,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 3,
                        width: 40,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 16),
                    Text('How You\'ll Train',
                        style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5)),
                    const SizedBox(height: 6),
                    Text('Three powerful modes to sharpen your critical mind',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    const _FeatureCard(
                        icon: Icons.assignment_rounded,
                        iconColor: AppColors.primary,
                        title: 'Daily Defense',
                        desc:
                            'Analyze real-world posts every day. Build your streak, earn XP, and train your eye for manipulation.'),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                        icon: Icons.map_rounded,
                        iconColor: AppColors.accentAmber,
                        title: 'Campaign Mode',
                        desc:
                            'Journey through curated challenges — from Ad Hominem to AI hallucinations. Structured and progressive.'),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                        icon: Icons.radar_rounded,
                        iconColor: AppColors.accentCyan,
                        title: 'Skill Radar',
                        desc:
                            'See your cognitive strengths and blind spots visualized. Know exactly where to improve.'),
                    const SizedBox(height: 32),
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

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String desc;
  const _FeatureCard(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg700,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(desc,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
