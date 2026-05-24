import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ============ ARGUMENTO APP BAR ============
class ArgumentoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBack;

  const ArgumentoAppBar({super.key, this.title, this.actions, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.zinc950,
      elevation: 0,
      automaticallyImplyLeading: showBack,
      title: title != null
          ? Text(
              title!.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Courier New',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1,
              ),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.zinc800),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

// ============ ACCENT BUTTON ============
class AccentButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? accentColor;
  final Widget? icon;

  const AccentButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.accentColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.green500;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(vertical: 18),
          disabledBackgroundColor: color.withOpacity(0.5),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ============ OUTLINED BUTTON ============
class ArgumentoOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;

  const ArgumentoOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? AppColors.zinc700;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.zinc300,
          side: BorderSide(color: color),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Courier New',
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

// ============ STAT CARD ============
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Widget? icon;
  final Color? accentColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.green500;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zinc950.withOpacity(0.5),
        border: Border(
          left: BorderSide(color: color, width: 3),
          top: BorderSide(color: AppColors.zinc800),
          right: BorderSide(color: AppColors.zinc800),
          bottom: BorderSide(color: AppColors.zinc800),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zinc500,
                  letterSpacing: 1.5,
                ),
              ),
              if (icon != null) icon!,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          if (subValue != null)
            Text(
              subValue!,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 11,
                color: AppColors.zinc600,
              ),
            ),
        ],
      ),
    );
  }
}

// ============ SECTION HEADER ============
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.zinc700),
        ],
      ),
    );
  }
}

// ============ FORM FIELD ============
class ArgumentoTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final String? errorText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Color accentColor;

  const ArgumentoTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.errorText,
    this.suffixIcon,
    this.keyboardType,
    this.accentColor = AppColors.green500,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Courier New',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.zinc500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Courier New',
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.zinc700, fontFamily: 'Courier New'),
            filled: true,
            fillColor: AppColors.zinc900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(color: AppColors.zinc800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(color: AppColors.zinc800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: accentColor, width: 2),
            ),
            errorText: errorText,
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.red),
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ============ LOADING OVERLAY ============
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final Color accentColor;

  const LoadingOverlay({super.key, this.message, this.accentColor = AppColors.green500});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: accentColor),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Courier New',
                color: accentColor,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============ EMPTY STATE ============
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;

  const EmptyState({super.key, required this.title, this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 16),
          ],
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.zinc500,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'Courier New',
                fontSize: 12,
                color: AppColors.zinc600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ============ SNACKBAR HELPER ============
class ArgumentoSnackBar {
  static void show(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? AppColors.red600 : AppColors.green600,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
