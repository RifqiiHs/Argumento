import 'package:flutter/material.dart';

/// Reusable progress bar component for XP and completion tracking.
/// Modern dark theme with neon green accent.
class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color textSecondary = Color(0xFFd4d4d8); // Light gray

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: accentColor.withOpacity(0.15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(progress * 100).toInt()}% Complete',
          style: const TextStyle(
            fontSize: 12,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
