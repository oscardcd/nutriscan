import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/ui.dart';
import '../../../../i18n/strings.g.dart';

class CriteriaCard extends StatelessWidget {
  const CriteriaCard({
    super.key,required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(t.capture.criteria),
          const SizedBox(height: AppSpacing.sm),
          ScanCriterion(label: t.capture.fullBody),
          ScanCriterion(label: t.capture.twoMeters),
          ScanCriterion(
            label: t.capture.plainBackground,
            icon: Icons.info_outline,
            ok: false,
          ),
          ScanCriterion(
            label: t.capture.looseClothing,
            icon: Icons.info_outline,
            ok: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.threesixty,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.capture.sideView,
                        style: theme.textTheme.labelLarge,
                      ),
                      Text(
                        t.capture.sideViewHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
