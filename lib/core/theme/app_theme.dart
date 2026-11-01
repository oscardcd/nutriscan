import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _radius = 16.0;

  static ThemeData get light => _build(
    scheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      surface: AppColors.sand,
    ),
  );

  static ThemeData get dark => _build(
    scheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData _build({required ColorScheme scheme}) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
      ),
    );
  }
}
