import 'package:flutter/material.dart';
import 'package:mobile/theme/app_colors.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final Widget? child;

  const NeonButton({
    super.key,
    this.label = '',
    this.onPressed,
    this.backgroundColor = AppColors.neon,
    this.foregroundColor = const Color.fromARGB(255, 0, 0, 0),
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = child != null
        ? child
        : icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon), const SizedBox(width: 8), Text(label)],
          )
        : Text(label);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      child: buttonChild,
    );
  }
}
