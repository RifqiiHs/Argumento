import 'package:flutter/material.dart';

/// Reusable reward card used in the shop screen.
class RewardCard extends StatelessWidget {
  final String name;
  final String description;
  final String cost;

  const RewardCard({super.key, required this.name, required this.description, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Text(cost, style: const TextStyle(fontSize: 14, color: Colors.indigo, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
