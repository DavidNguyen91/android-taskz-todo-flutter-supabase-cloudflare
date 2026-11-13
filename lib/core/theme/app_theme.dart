import 'package:flutter/material.dart';

/// Apple iOS Design System specifications.
/// Extracted directly from Next.js CSS variables in `app/globals.css`.
abstract final class AppColors {
  // Light Palette
  static const Color lightCanvas = Color(0xFFF2F2F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightInput = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF2F2F7);
  static const Color lightHover = Color(0x0A000000); // rgba(0, 0, 0, 0.04)
  static const Color lightActive = Color(0x14000000); // rgba(0, 0, 0, 0.08)

  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color lightTextTertiary = Color(0xFFC7C7CC);
  static const Color lightTextPlaceholder = Color(0xFFAEAEB2);

  static const Color lightAccent = Color(0xFF007AFF);
  static const Color lightAccentHover = Color(0xFF0062CC);
  static const Color lightAccentSubtle = Color(0x14007AFF); // rgba(0, 122, 255, 0.08)

  static const Color lightDanger = Color(0xFFFF3B30);
  static const Color lightDangerHover = Color(0xFFD70015);
  static const Color lightDangerSubtle = Color(0x14FF3B30); // rgba(255, 59, 48, 0.08)

  static const Color lightSuccess = Color(0xFF34C759);

  static const Color lightBorderSubtle = Color(0x1F3C3C43); // rgba(60, 60, 67, 0.12)
  static const Color lightBorderDivider = Color(0x143C3C43); // rgba(60, 60, 67, 0.08)

  // Dark Palette
  static const Color darkCanvas = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1C1C1E);
  static const Color darkInput = Color(0xFF2C2C2E);
  static const Color darkSecondary = Color(0xFF2C2C2E);
  static const Color darkHover = Color(0x0FFFFFFF); // rgba(255, 255, 255, 0.06)
  static const Color darkActive = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.10)

  static const Color darkTextPrimary = Color(0xFFF5F5F7);
  static const Color darkTextSecondary = Color(0xFF98989D);
  static const Color darkTextTertiary = Color(0xFF636366);
  static const Color darkTextPlaceholder = Color(0xFF8E8E93);

  static const Color darkAccent = Color(0xFF0A84FF);
  static const Color darkAccentHover = Color(0xFF409CFF);
  static const Color darkAccentSubtle = Color(0x290A84FF); // rgba(10, 132, 255, 0.16)

  static const Color darkDanger = Color(0xFFFF453A);
  static const Color darkDangerHover = Color(0xFFFF6961);
  static const Color darkDangerSubtle = Color(0x29FF453A); // rgba(255, 69, 58, 0.16)

  static const Color darkSuccess = Color(0xFF30D158);

  static const Color darkBorderSubtle = Color(0x1FFFFFFF); // rgba(255, 255, 255, 0.12)
  static const Color darkBorderDivider = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)
}

/// Geometry and Spacing tokens matching iOS standards.
abstract final class AppGeometry {
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusCard = 16.0;
  static const double radiusFull = 9999.0;

  static const double minTouchTarget = 44.0; // WCAG & iOS HIG min touch size
}

/// AppTheme builds ThemeData respecting iOS aesthetics and dark mode.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightCanvas,
      canvasColor: AppColors.lightCanvas,
      cardColor: AppColors.lightCard,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        surface: AppColors.lightCard,
        error: AppColors.lightDanger,
        onPrimary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),
      dividerColor: AppColors.lightBorderDivider,
      fontFamily: '-apple-system',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkCanvas,
      canvasColor: AppColors.darkCanvas,
      cardColor: AppColors.darkCard,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        surface: AppColors.darkCard,
        error: AppColors.darkDanger,
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      dividerColor: AppColors.darkBorderDivider,
      fontFamily: '-apple-system',
    );
  }
}
