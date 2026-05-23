import 'package:flutter/material.dart';

/// Reusable button widget used across the Argumento prototype.
/// Modern dark theme with neon green accent.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF22c55e); // Neon green
    const Color darkBg = Color(0xFF09090b);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? (isPrimary ? accentColor : darkBg),
        foregroundColor: isPrimary ? darkBg : accentColor,
        elevation: isPrimary ? 0 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: accentColor.withOpacity(0.4), width: 1.5),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isPrimary ? darkBg : accentColor,
        ),
      ),
    );
  }
}
