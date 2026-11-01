import 'package:flutter/material.dart';

/// Tokens de color de DESIGN.md (front-matter + sección Colors).
abstract final class AppColors {
  // Canvas & surfaces (light)
  static const canvas = Color(0xFFF7F5F0);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFEDF4FF);
  static const surfaceContainer = Color(0xFFE4EFFD);
  static const surfaceContainerHigh = Color(0xFFDFE9F7);
  static const surfaceContainerHighest = Color(0xFFD9E3F1);
  static const surfaceDim = Color(0xFFD1DBE8);

  // Strokes
  static const outline = Color(0xFFE2E8F0);
  static const outlineVariant = Color(0xFFBFC8C8);

  // Brand
  static const primary = Color(0xFF0F5B5B);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryDeep = Color(0xFF004242);
  static const mint = Color(0xFFE6F4F1);
  static const onMint = Color(0xFF004242);
  static const secondary = Color(0xFF54615F);
  static const secondaryContainer = Color(0xFFD7E5E2);

  // Text
  static const textPrimary = Color(0xFF1F2933);
  static const textSecondary = Color(0xFF5B6B7A);
  static const inverseSurface = Color(0xFF27313C);
  static const inverseOnSurface = Color(0xFFE8F2FF);

  // Diagnostic bands
  static const bandUnderweight = Color(0xFF3B82F6);
  static const bandUnderweightText = Color(0xFF1D4ED8);
  static const bandNormal = Color(0xFF10B981);
  static const bandNormalText = Color(0xFF047857);
  static const bandOverweight = Color(0xFFE8A33D);
  static const bandOverweightText = Color(0xFFB45309);
  static const bandObese = Color(0xFFC4573F);
  static const bandObeseText = Color(0xFF991B1B);

  // Disclaimer
  static const disclaimerSurface = Color(0xFFEFECE6);
  static const disclaimerBorder = Color(0xFF5B6B7A);

  // Dark surfaces (DESIGN.md solo define claro; derivados tonales del teal)
  static const darkCanvas = Color(0xFF0E1417);
  static const darkSurface = Color(0xFF161E22);
  static const darkSurfaceContainerLow = Color(0xFF1B2529);
  static const darkSurfaceContainer = Color(0xFF202B30);
  static const darkSurfaceContainerHigh = Color(0xFF263136);
  static const darkOutline = Color(0xFF2E3B40);
  static const darkTextPrimary = Color(0xFFE6ECEF);
  static const darkTextSecondary = Color(0xFFA6B4BA);
  static const darkPrimary = Color(0xFF90D2D1);
  static const darkPrimaryContainer = Color(0xFF0B4646);
  static const darkOnPrimaryContainer = Color(0xFFACE7E6);
}

/// Escala 8pt con medio paso de 4pt (DESIGN.md §Layout).
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  static const gutter = 16.0;
  static const gutterMobile = 12.0;
  static const margin = 20.0;
  static const marginMobile = 16.0;
}

/// Radios: base 8, contenedor 16, pill full (DESIGN.md §Shapes).
abstract final class AppRadius {
  static const sm = 4.0;
  static const base = 8.0;
  static const md = 12.0;
  static const container = 16.0;
  static const xl = 24.0;
  static const full = 9999.0;
}
