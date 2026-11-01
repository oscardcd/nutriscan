import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/widgets/medical_disclaimer.dart';
import '../../../core/ui/ui.dart';
import '../../../i18n/strings.g.dart';
import '../data/consent_gate.dart';

/// Bienvenida + consentimiento explícito. Única puerta de entrada a la medición.
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _acceptScreening = false;
  bool _acceptProcessing = false;

  bool get _canContinue => _acceptScreening && _acceptProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: t.appTitle,
              subtitle: t.consent.subtitle,
              pillText: t.onDevice.pill,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.lg,
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                ),
                children: [
                  Text(t.consent.heroTitle, style: theme.textTheme.headlineLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    t.consent.heroBody,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InfoCard(
                    icon: Icons.phonelink_lock,
                    title: t.consent.deviceTitle,
                    body: t.consent.deviceBody,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoCard(
                    icon: Icons.shield_outlined,
                    title: t.consent.privacyTitle,
                    body: t.consent.privacyBody,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoCard(
                    icon: Icons.health_and_safety_outlined,
                    title: t.consent.screeningTitle,
                    body: t.consent.screeningBody,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionLabel(
                    t.consent.termsTitle,
                    trailing: StatusPill(text: t.consent.required),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    t.consent.termsBody,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ConsentCheckbox(
                    prefix: t.consent.screeningPrefix,
                    highlight: t.consent.screeningHighlight,
                    suffix: t.consent.screeningSuffix,
                    value: _acceptScreening,
                    onChanged: (v) => setState(() => _acceptScreening = v),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ConsentCheckbox(
                    prefix: t.consent.processingPrefix,
                    highlight: t.consent.processingHighlight,
                    suffix: t.consent.processingSuffix,
                    value: _acceptProcessing,
                    onChanged: (v) => setState(() => _acceptProcessing = v),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const MedicalDisclaimer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.sm,
                AppSpacing.marginMobile,
                AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canContinue
                      // El guard del router redirige a /capture al notificar.
                      ? () => ref.read(consentGateProvider).grant()
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.consent.cta),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.arrow_forward, size: 18),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
