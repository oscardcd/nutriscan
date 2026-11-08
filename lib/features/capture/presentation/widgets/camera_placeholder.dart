import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CameraPlaceholder extends StatelessWidget {
  const CameraPlaceholder({
    super.key,
    required this.isLoading,
    required this.message,
    required this.startLabel,
    this.onStart,
  });

  final bool isLoading;
  final String message;
  final String startLabel;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              Icon(
                Icons.photo_camera_outlined,
                size: 44,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message, textAlign: TextAlign.center),
            ],
            if (onStart != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(startLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
