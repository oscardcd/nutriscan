import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'app_card.dart';

/// Consentimiento explícito para dato sensible (foto corporal).
class ConsentCheckbox extends StatelessWidget {
  const ConsentCheckbox({
    super.key,
    required this.prefix,
    required this.highlight,
    required this.suffix,
    required this.value,
    required this.onChanged,
  });

  final String prefix;
  final String highlight;
  final String suffix;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyMedium!;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      onTap: onChanged == null ? null : () => onChanged!(!value),
      // MergeSemantics: casilla + texto se leen como un solo control marcable.
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged == null
                  ? null
                  : (v) => onChanged!(v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text.rich(
                  TextSpan(
                    style: body,
                    children: [
                      TextSpan(text: prefix),
                      TextSpan(
                        text: highlight,
                        style: body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      TextSpan(text: suffix),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
