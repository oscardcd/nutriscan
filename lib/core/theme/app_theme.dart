import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// ThemeData construido a mano desde DESIGN.md (no `fromSeed`: los tokens son fijos).
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.darkPrimary : AppColors.primary,
      onPrimary: isDark ? const Color(0xFF00302F) : AppColors.onPrimary,
      primaryContainer: isDark
          ? AppColors.darkPrimaryContainer
          : AppColors.mint,
      onPrimaryContainer: isDark
          ? AppColors.darkOnPrimaryContainer
          : AppColors.onMint,
      secondary: isDark ? AppColors.secondaryContainer : AppColors.secondary,
      onSecondary: isDark ? const Color(0xFF121E1C) : AppColors.onPrimary,
      secondaryContainer: isDark
          ? AppColors.darkSurfaceContainerHigh
          : AppColors.secondaryContainer,
      onSecondaryContainer: isDark
          ? AppColors.darkTextPrimary
          : const Color(0xFF3D4947),
      tertiary: isDark ? AppColors.bandOverweight : const Color(0xFF533400),
      onTertiary: AppColors.onPrimary,
      tertiaryContainer: isDark
          ? const Color(0xFF724900)
          : const Color(0xFFFFDDB5),
      onTertiaryContainer: isDark
          ? const Color(0xFFFFDDD5)
          : const Color(0xFF2A1800),
      error: isDark ? const Color(0xFFFFB4AB) : AppColors.bandObese,
      onError: isDark ? const Color(0xFF690005) : AppColors.onPrimary,
      errorContainer: isDark
          ? const Color(0xFF93000A)
          : const Color(0xFFFFDAD6),
      onErrorContainer: isDark
          ? const Color(0xFFFFDAD6)
          : const Color(0xFF93000A),
      surface: isDark ? AppColors.darkSurface : AppColors.surface,
      onSurface: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      surfaceContainerLowest: isDark
          ? AppColors.darkCanvas
          : AppColors.surfaceContainerLowest,
      surfaceContainerLow: isDark
          ? AppColors.darkSurfaceContainerLow
          : AppColors.surfaceContainerLow,
      surfaceContainer: isDark
          ? AppColors.darkSurfaceContainer
          : AppColors.surfaceContainer,
      surfaceContainerHigh: isDark
          ? AppColors.darkSurfaceContainerHigh
          : AppColors.surfaceContainerHigh,
      surfaceContainerHighest: isDark
          ? AppColors.darkSurfaceContainerHigh
          : AppColors.surfaceContainerHighest,
      onSurfaceVariant: isDark
          ? AppColors.darkTextSecondary
          : AppColors.textSecondary,
      outline: isDark ? AppColors.darkOutline : AppColors.outline,
      outlineVariant: isDark ? AppColors.darkOutline : AppColors.outlineVariant,
      inverseSurface: isDark
          ? AppColors.inverseOnSurface
          : AppColors.inverseSurface,
      onInverseSurface: isDark
          ? AppColors.inverseSurface
          : AppColors.inverseOnSurface,
      surfaceTint: isDark ? AppColors.darkPrimary : AppColors.primary,
    );

    final textTheme = AppTypography.textTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );
    final canvas = isDark ? AppColors.darkCanvas : AppColors.canvas;
    final radius = BorderRadius.circular(AppRadius.container);

    return ThemeData(
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: canvas,
      // Level 1: borde hairline + sombra ambiente muy suave.
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: scheme.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: scheme.surfaceContainerHighest,
          disabledForegroundColor: scheme.onSurfaceVariant,
          minimumSize: const Size.fromHeight(48),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: textTheme.labelLarge,
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          textStyle: textTheme.labelLarge,
          foregroundColor: scheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        helperStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        suffixStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: isDark
            ? AppColors.darkPrimaryContainer
            : AppColors.mint,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
      ),
    );
  }
}
