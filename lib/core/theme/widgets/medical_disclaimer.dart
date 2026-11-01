import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../app_colors.dart';

/// Aviso de tamizaje (DESIGN.md §Medical Disclaimers). Nunca diagnóstico.
class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark
            ? AppColors.darkSurfaceContainerLow
            : AppColors.disclaimerSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: dark
                ? AppColors.darkTextSecondary
                : AppColors.disclaimerBorder,
            width: 2,
          ),
        ),
      ),
      child: Text(
        Translations.of(context).disclaimer.screening,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
