import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// DESIGN SYSTEM — Argumento
// Modern dark theme: deep forest-black + emerald green
// ============================================================

class AppColors {
  // Backgrounds — layered depth, not flat black
  static const bg900 = Color(0xFF0A0F0A);  // page background
  static const bg800 = Color(0xFF0F1610);  // card
  static const bg700 = Color(0xFF141E15);  // elevated card
  static const bg600 = Color(0xFF1A2A1B);  // input / chip
  static const bg500 = Color(0xFF213023);  // subtle highlight

  // Borders
  static const border      = Color(0xFF243526);
  static const borderLight = Color(0xFF2E4530);

  // Primary green — rich, not neon
  static const primary    = Color(0xFF34D058);
  static const primaryDim = Color(0xFF22863A);
  static const primaryBg  = Color(0xFF0D2818);

  // Text hierarchy
  static const textPrimary   = Color(0xFFF0F6F1);
  static const textSecondary = Color(0xFFACBDAE);
  static const textMuted     = Color(0xFF5E7A62);
  static const textDisabled  = Color(0xFF374B39);

  // Semantic
  static const success   = Color(0xFF34D058);
  static const successBg = Color(0xFF0D2818);
  static const error     = Color(0xFFFF6B6B);
  static const errorBg   = Color(0xFF2D0F0F);
  static const warning   = Color(0xFFFFB347);
  static const warningBg = Color(0xFF2D1F00);
  static const info      = Color(0xFF5BC0F8);
  static const infoBg    = Color(0xFF071D2D);

  // Theme accents
  static const accentGreen = Color(0xFF34D058);
  static const accentWhite = Color(0xFFEEF2EE);
  static const accentAmber = Color(0xFFFFB347);
  static const accentCyan  = Color(0xFF5BC0F8);
  static const accentRed   = Color(0xFFFF6B6B);
}

class AppTheme {
  static ThemeData getTheme(String themeId) {
    final accent = getAccentColor(themeId);

    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge:  GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 36, letterSpacing: -1.5),
      displayMedium: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -1),
      headlineLarge: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: -0.5),
      headlineMedium:GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
      headlineSmall: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 17),
      titleLarge:    GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
      titleMedium:   GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge:     GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16, height: 1.6),
      bodyMedium:    GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
      bodySmall:     GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12, height: 1.4),
      labelLarge:    GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium:   GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall:    GoogleFonts.inter(color: AppColors.textMuted, fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg900,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent.withValues(alpha: 0.7),
        surface: AppColors.bg800,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      // FIX: use CardThemeData not CardTheme
      cardTheme: CardThemeData(
        color: AppColors.bg800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bg600,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: accent, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
        hintStyle: GoogleFonts.inter(color: AppColors.textDisabled, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
        errorStyle: GoogleFonts.inter(color: AppColors.error, fontSize: 11),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bg800,
        selectedItemColor: accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: AppColors.bg500,
        linearMinHeight: 6,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bg700,
        contentTextStyle: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Color getAccentColor(String themeId) {
    switch (themeId) {
      case 'theme_green':    return AppColors.accentGreen;
      case 'theme_obsidian': return AppColors.accentWhite;
      case 'theme_amber':    return AppColors.accentAmber;
      case 'theme_cyan':     return AppColors.accentCyan;
      case 'theme_red':      return AppColors.accentRed;
      default:               return AppColors.accentGreen;
    }
  }

  static Color getMutedAccentColor(String themeId) {
    return getAccentColor(themeId).withValues(alpha: 0.15);
  }
}

// ── Design tokens ────────────────────────────────────────────
class AppSpacing {
  static const xs   = 4.0;
  static const sm   = 8.0;
  static const md   = 12.0;
  static const lg   = 16.0;
  static const xl   = 20.0;
  static const xxl  = 24.0;
  static const xxxl = 32.0;
}

class AppRadius {
  static const sm   = Radius.circular(6);
  static const md   = Radius.circular(10);
  static const lg   = Radius.circular(14);
  static const xl   = Radius.circular(20);
  static const full = Radius.circular(100);
}

// FIX: glow must be a method, not a getter with parameter
class AppShadow {
  static List<BoxShadow> glowColor(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 16,
      offset: Offset.zero,
    ),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

// Extension for convenience — uses withValues (not deprecated withOpacity)
extension ShadowExt on Color {
  List<BoxShadow> get glow => [
    BoxShadow(
      color: withValues(alpha: 0.2),
      blurRadius: 16,
      offset: Offset.zero,
    ),
  ];
}
