import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Superficie base del sistema: blanco, radio 16, borde hairline, sombra nivel 1
/// (DESIGN.md §Elevation & Depth).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.container);
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? scheme.surface,
        borderRadius: radius,
        border: Border.all(color: scheme.outline),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2933).withValues(alpha: 0.04),
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return InkWell(borderRadius: radius, onTap: onTap, child: content);
  }
}
