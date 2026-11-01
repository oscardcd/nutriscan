import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografía Inter de DESIGN.md §Typography. `letterSpacing` va en px (em × size).
abstract final class AppTypography {
  static const _tabular = [FontFeature.tabularFigures()];

  static TextTheme textTheme(TextTheme base) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      // Metric display: solo para IMC, % grasa, masa muscular.
      displayLarge: inter.displayLarge?.copyWith(
        fontSize: 48,
        height: 52 / 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.44,
        fontFeatures: _tabular,
      ),
      displayMedium: inter.displayMedium?.copyWith(
        fontSize: 40,
        height: 44 / 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        fontFeatures: _tabular,
      ),
      headlineLarge: inter.headlineLarge?.copyWith(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.64,
      ),
      headlineMedium: inter.headlineMedium?.copyWith(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.22,
      ),
      headlineSmall: inter.headlineSmall?.copyWith(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.09,
      ),
      bodyLarge: inter.bodyLarge?.copyWith(fontSize: 16, height: 24 / 16),
      bodyMedium: inter.bodyMedium?.copyWith(fontSize: 14, height: 20 / 14),
      labelLarge: inter.labelLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.14,
      ),
      // Micro-labels (STATUS / ESTADO): únicos que van en mayúsculas.
      labelMedium: inter.labelMedium?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.22,
      ),
    );
  }
}
