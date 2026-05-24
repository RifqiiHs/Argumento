import 'package:flutter/material.dart';

class AppTheme {
  // Theme color definitions (mirrors web themes.ts)
  static const Map<String, ThemeData> themes = {};

  static ThemeData getTheme(String themeId) {
    final accentColor = getAccentColor(themeId);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF09090B), // zinc-950
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        surface: const Color(0xFF18181B), // zinc-900
        onSurface: const Color(0xFFD4D4D8), // zinc-300
        background: const Color(0xFF09090B),
      ),
      cardColor: const Color(0xFF18181B),
      dividerColor: const Color(0xFF3F3F46), // zinc-700
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 40,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Courier New',
          color: const Color(0xFFD4D4D8),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Courier New',
          color: const Color(0xFFA1A1AA), // zinc-400
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Courier New',
          color: const Color(0xFF71717A), // zinc-500
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF18181B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: Color(0xFF3F3F46)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: Color(0xFF3F3F46)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF3F3F46)),
        labelStyle: const TextStyle(
          color: Color(0xFF71717A),
          fontFamily: 'Courier New',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(
            fontFamily: 'Courier New',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  static Color getAccentColor(String themeId) {
    switch (themeId) {
      case 'theme_green':
        return const Color(0xFF22C55E);
      case 'theme_obsidian':
        return const Color(0xFFF4F4F5);
      case 'theme_amber':
        return const Color(0xFFF59E0B);
      case 'theme_cyan':
        return const Color(0xFF22D3EE);
      case 'theme_red':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF22C55E);
    }
  }

  static Color getMutedAccentColor(String themeId) {
    switch (themeId) {
      case 'theme_green':
        return const Color(0xFF22C55E).withOpacity(0.25);
      case 'theme_obsidian':
        return const Color(0xFFF4F4F5).withOpacity(0.25);
      case 'theme_amber':
        return const Color(0xFFF59E0B).withOpacity(0.25);
      case 'theme_cyan':
        return const Color(0xFF22D3EE).withOpacity(0.25);
      case 'theme_red':
        return const Color(0xFFEF4444).withOpacity(0.25);
      default:
        return const Color(0xFF22C55E).withOpacity(0.25);
    }
  }
}

// Theme-aware colors
class AppColors {
  static const zinc950 = Color(0xFF09090B);
  static const zinc900 = Color(0xFF18181B);
  static const zinc800 = Color(0xFF27272A);
  static const zinc700 = Color(0xFF3F3F46);
  static const zinc600 = Color(0xFF52525B);
  static const zinc500 = Color(0xFF71717A);
  static const zinc400 = Color(0xFFA1A1AA);
  static const zinc300 = Color(0xFFD4D4D8);
  static const zinc200 = Color(0xFFE4E4E7);
  static const zinc100 = Color(0xFFF4F4F5);

  static const green500 = Color(0xFF22C55E);
  static const green600 = Color(0xFF16A34A);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const yellow500 = Color(0xFFEAB308);
  static const amber600 = Color(0xFFD97706);
}
