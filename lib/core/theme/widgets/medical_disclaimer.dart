import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Aviso de tamizaje (DESIGN.md §Medical Disclaimers). Nunca diagnóstico.
class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({
    super.key,
    this.text =
        'Estimación de tamizaje. No es un diagnóstico. '
        'Consulte a un profesional de la salud para una evaluación.',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? AppColors.darkSurfaceContainerLow : AppColors.disclaimerSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: dark ? AppColors.darkTextSecondary : AppColors.disclaimerBorder,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
