import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/widgets/medical_disclaimer.dart';
import '../../../i18n/strings.g.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.accessibility_new,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                t.capture.headline,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                t.capture.body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: null,
                child: Text(t.capture.cta),
              ),
              const SizedBox(height: AppSpacing.md),
              const MedicalDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }
}
