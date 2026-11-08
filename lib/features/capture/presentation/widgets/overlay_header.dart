import 'package:flutter/material.dart';

import '../../../../core/settings/settings_menu.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

class OverlayHeader extends StatelessWidget {
  const OverlayHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.foreground,
    this.onBack,
    this.onInfo,
  });

  final String title;
  final String subtitle;
  final Color foreground;
  final VoidCallback? onBack;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadow = [
      Shadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 8),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        0,
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: Icon(Icons.arrow_back, color: foreground),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: foreground,
                    shadows: shadow,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: 0.8),
                    shadows: shadow,
                  ),
                ),
              ],
            ),
          ),
          const SettingsMenu(),
          if (onInfo != null)
            IconButton(
              onPressed: onInfo,
              tooltip: Translations.of(context).capture.criteria,
              icon: Icon(Icons.info_outline, color: foreground),
            ),
        ],
      ),
    );
  }
}
