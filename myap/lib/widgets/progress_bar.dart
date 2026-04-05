import 'package:flutter/material.dart';

/// Reusable progress bar component for XP and completion tracking.
class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          color: Colors.indigo,
          backgroundColor: const Color.fromRGBO(63, 81, 181, 0.18),
          minHeight: 12,
        ),
        const SizedBox(height: 8),
        Text('${(progress * 100).toInt()}% complete', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
