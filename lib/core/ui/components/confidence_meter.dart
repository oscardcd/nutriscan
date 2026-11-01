import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum ConfidenceLevel { low, medium, high }

extension ConfidenceLevelColor on ConfidenceLevel {
  Color get color => switch (this) {
    ConfidenceLevel.low => AppColors.bandObese,
    ConfidenceLevel.medium => AppColors.bandOverweight,
    ConfidenceLevel.high => AppColors.bandNormal,
  };

  int get filledSegments => switch (this) {
    ConfidenceLevel.low => 1,
    ConfidenceLevel.medium => 2,
    ConfidenceLevel.high => 3,
  };
}

/// Medidor de 3 segmentos con etiqueta textual (DESIGN.md: confianza explícita).
class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({super.key, required this.level, required this.label});

  final ConfidenceLevel level;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        // El Text de al lado ya anuncia el nivel; los segmentos son decorativos.
        ExcludeSemantics(
          child: Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Container(
                  width: 18,
                  height: 4,
                  decoration: BoxDecoration(
                    color: i < level.filledSegments
                        ? level.color
                        : theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: level != ConfidenceLevel.high
                  ? theme.colorScheme.onSurfaceVariant
                  // Mismo criterio que BmiBandChip para contraste en oscuro.
                  : dark
                  ? Color.lerp(level.color, Colors.white, 0.45)
                  : AppColors.bandNormalText,
            ),
          ),
        ),
      ],
    );
  }
}
