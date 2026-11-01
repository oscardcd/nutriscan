import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'section_label.dart';

/// Métrica principal (IMC): etiqueta micro, número grande con unidad en baseline.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.caption,
    this.trailing,
    this.compact = false,
  });

  final String label;
  final String value;
  final String unit;
  final String? caption;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = compact
        ? theme.textTheme.displayMedium
        : theme.textTheme.displayLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label, trailing: trailing),
        const SizedBox(height: AppSpacing.sm),
        // Con texto grande, número y unidad se reducen juntos sin perder baseline.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: valueStyle),
              const SizedBox(width: AppSpacing.xs),
              Text(
                unit,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
