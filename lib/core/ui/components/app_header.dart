import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'status_pill.dart';

/// Header de sección: marca, subtítulo de pantalla, pill on-device y acciones.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.pillText,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final String? pillText;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Con texto muy grande la pill empuja el título fuera de pantalla.
    final compact = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.health_and_safety,
            color: theme.colorScheme.primary,
            size: 30,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (pillText != null && !compact) ...[
            StatusPill(text: pillText!, icon: Icons.lock_outline),
            const SizedBox(width: AppSpacing.sm),
          ],
          ...actions,
        ],
      ),
    );
  }
}
