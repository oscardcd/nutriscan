import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'status_pill.dart';

/// Header de sección: marca, subtítulo de pantalla, pill on-device y avatar.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.pillText,
    this.onProfileTap,
    this.profileTooltip,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final String? pillText;
  final VoidCallback? onProfileTap;
  final List<Widget> actions;

  /// Etiqueta del avatar. Obligatoria cuando [onProfileTap] existe.
  final String? profileTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (pillText != null) ...[
            StatusPill(text: pillText!, icon: Icons.lock_outline),
            const SizedBox(width: AppSpacing.sm),
          ],
          ...actions,
          // Sin acción no se muestra: un avatar muerto es ruido y un target falso.
          if (onProfileTap != null)
            IconButton(
              onPressed: onProfileTap,
              tooltip: profileTooltip,
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                child: Icon(
                  Icons.person_outline,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
