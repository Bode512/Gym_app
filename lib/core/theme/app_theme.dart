import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { deepSlate, cyberNeon, crimsonBlood, goldRush }

class AppColors {
  // Deep Dark Luxury Colors
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceSoft = Color(0xFF2A2A2A);
  static const Color borderDark = Color(0x26C9A24B);
  static const Color borderSubtle = Color(0x1FFFFFFF);

  // Champagne Gold Accent & Brand Colors
  static const Color goldPrimary = Color(0xFFC9A24B);
  static const Color goldLight = Color(0xFFE2C475);
  static const Color goldDark = Color(0xFF9E7B2F);

  // Status Colors (Warm & Muted to maintain luxury aesthetic)
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);

  // Text Colors
  static const Color textPrimary = Color(0xFFF2F0EB);   // Bone white
  static const Color textSecondary = Color(0xFFA0A0A0); // Light graphite
  static const Color textMuted = Color(0xFF666666);     // Soft gray
}

class AppThemes {
  static ThemeData getTheme(AppTheme theme) {
    Color bg;
    Color primary;
    Color cardBg;

    switch (theme) {
      case AppTheme.cyberNeon:
        bg = const Color(0xFF050B14);
        primary = const Color(0xFF00F5FF);
        cardBg = const Color(0xFF0D1726);
        break;
      case AppTheme.crimsonBlood:
        bg = const Color(0xFF120707);
        primary = const Color(0xFFFF3B30);
        cardBg = const Color(0xFF1F0E0E);
        break;
      case AppTheme.goldRush:
        bg = const Color(0xFF0F0E0A);
        primary = const Color(0xFFFFD700);
        cardBg = const Color(0xFF1C1A12);
        break;
      case AppTheme.deepSlate:
      default:
        bg = AppColors.backgroundDark;
        primary = AppColors.goldPrimary;
        cardBg = AppColors.surfaceDark;
    }

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        background: bg,
        surface: cardBg,
        primary: primary,
        secondary: primary.withOpacity(0.8),
        error: AppColors.error,
      ),
      textTheme: textTheme,

      // Card Theme
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.goldPrimary),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF0D0D0D), // Dark text on gold button for high contrast
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary.withOpacity(0.6), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceSoft,
        disabledColor: AppColors.surfaceDark,
        selectedColor: primary,
        secondarySelectedColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),

      // Expansion Tile Theme
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border.fromBorderSide(BorderSide(color: Colors.transparent)),
        collapsedShape: Border.fromBorderSide(BorderSide(color: Colors.transparent)),
      ),
    );
  }

  static Color getAccentColor(AppTheme theme) {
    switch (theme) {
      case AppTheme.cyberNeon: return const Color(0xFF00F5FF);
      case AppTheme.crimsonBlood: return const Color(0xFFFF3B30);
      case AppTheme.goldRush: return const Color(0xFFFFD700);
      default: return AppColors.goldPrimary;
    }
  }

  static Color getCardColor(AppTheme theme) {
    switch (theme) {
      case AppTheme.cyberNeon: return const Color(0xFF0D1726);
      case AppTheme.crimsonBlood: return const Color(0xFF1F0E0E);
      case AppTheme.goldRush: return const Color(0xFF1C1A12);
      default: return AppColors.surfaceDark;
    }
  }
}

