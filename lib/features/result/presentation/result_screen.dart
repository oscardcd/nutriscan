import 'package:flutter/material.dart';
import '../../../core/settings/settings_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/widgets/bmi_band_chip.dart';
import '../../../core/theme/widgets/bmi_range_gauge.dart';
import '../../../core/theme/widgets/medical_disclaimer.dart';
import '../../../core/ui/ui.dart';
import '../../classify/domain/bmi_band.dart';
import '../../classify/domain/screening_outcome.dart';
import '../../classify/domain/screening_result.dart';
import '../../../i18n/strings.g.dart';

/// Resultado de cribado. Nunca se presenta como diagnóstico.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.outcome});

  final ScreeningOutcome outcome;

  @override
  Widget build(BuildContext context) {
    // Sin estimación válida no se muestran cifras: solo el motivo y cómo repetir.
    if (outcome case final ScreeningAbstention abstention) {
      return _AbstentionScreen(abstention: abstention);
    }
    final result = (outcome as ScreeningPrediction).result;
    final theme = Theme.of(context);
    final t = Translations.of(context);
    // Separador decimal según idioma: "27,4" en es, "27.4" en en.
    String n(double v, [int digits = 1]) =>
        (NumberFormat.decimalPattern(t.$meta.locale.languageCode)
              ..minimumFractionDigits = digits
              ..maximumFractionDigits = digits)
            .format(v);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: t.appTitle,
              subtitle: t.result.subtitle,
              pillText: t.onDevice.pill,
              onProfileTap: () => context.go('/profile'),
              profileTooltip: t.profile.title,
              actions: const [SettingsMenu()],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                ),
                children: [
                  SectionLabel(t.result.screeningLabel),
                  const SizedBox(height: AppSpacing.sm),
                  if (result.bmi case final bmi?) ...[
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MetricTile(
                            label: t.result.bmiLabel,
                            value: n(bmi),
                            unit: 'kg/m²',
                            trailing: result.band == null
                                ? null
                                : BmiBandChip(band: result.band!),
                            caption: _bmiCaption(t, result),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          BmiRangeGauge(bmi: bmi, label: t.result.scaleTitle),
                          if (result.confidence case final confidence?) ...[
                            const SizedBox(height: AppSpacing.md),
                            ConfidenceMeter(
                              level: switch (confidence) {
                                ScreeningConfidence.low => ConfidenceLevel.low,
                                ScreeningConfidence.medium =>
                                  ConfidenceLevel.medium,
                                ScreeningConfidence.high => ConfidenceLevel.high,
                              },
                              label: switch (confidence) {
                                ScreeningConfidence.low =>
                                  t.result.confidenceLow,
                                ScreeningConfidence.medium =>
                                  t.result.confidenceMedium,
                                ScreeningConfidence.high =>
                                  t.result.confidenceHigh,
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(t.result.scaleTitle),
                          const SizedBox(height: AppSpacing.sm),
                          for (final row in _scaleRows)
                            _ScaleRow(
                              band: row.$1,
                              range: row.$2,
                              label: bandLabel(row.$1, t),
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (result.waistToHeight case final whtr?) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MetricTile(
                            label: t.result.whtr,
                            value: n(whtr, 2),
                            unit: '',
                            caption: t.result.whtrExperimental,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  t.result.whtrWarning,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                t.result.meaningTitle,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          t.result.meaningBody,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                  onPressed: () => context.go('/capture'),
                  child: Text(t.result.cta),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// IMC estimado por el modelo (con margen) o calculado con peso y estatura.
String _bmiCaption(Translations t, ScreeningResult result) {
  final margin = result.margin;
  final min = result.bmiMin;
  final max = result.bmiMax;
  if (margin == null || min == null || max == null) {
    return t.result.bmiComputedCaption;
  }
  final n = NumberFormat.decimalPattern(t.$meta.locale.languageCode)
    ..minimumFractionDigits = 1
    ..maximumFractionDigits = 1;
  return t.result.rangeCaption(
    margin: n.format(margin),
    min: n.format(min),
    max: n.format(max),
  );
}

/// Cortes OMS para adultos. Los números no se traducen.
const _scaleRows = <(BmiBand, String)>[
  (BmiBand.underweight, '< 18.5'),
  (BmiBand.normal, '18.5 – 24.9'),
  (BmiBand.overweight, '25.0 – 29.9'),
  (BmiBand.obese, '≥ 30.0'),
];

class _ScaleRow extends StatelessWidget {
  const _ScaleRow({
    required this.band,
    required this.range,
    required this.label,
  });

  final BmiBand band;
  final String range;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: band.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Flexible(
            child: Text(
              range,
              textAlign: TextAlign.end,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado sin estimación: explica el motivo y devuelve a la captura.
class _AbstentionScreen extends StatelessWidget {
  const _AbstentionScreen({required this.abstention});

  final ScreeningAbstention abstention;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final (icon, title, body) = switch (abstention.reason) {
      ScreeningAbstentionReason.poseNotUsable => (
        Icons.person_search_outlined,
        t.result.abstainPoseTitle,
        t.result.abstainPoseBody,
      ),
      ScreeningAbstentionReason.alignmentFailed => (
        Icons.crop_free,
        t.result.abstainAlignmentTitle,
        t.result.abstainAlignmentBody,
      ),
      ScreeningAbstentionReason.noModel => (
        Icons.science_outlined,
        t.result.abstainNoModelTitle,
        t.result.abstainNoModelBody,
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: t.appTitle,
              subtitle: t.result.subtitle,
              pillText: t.onDevice.pill,
              onProfileTap: () => context.go('/profile'),
              profileTooltip: t.profile.title,
              actions: const [SettingsMenu()],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                ),
                children: [
                  SectionLabel(t.result.noEstimateLabel),
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 32, color: theme.colorScheme.primary),
                        const SizedBox(height: AppSpacing.sm),
                        Text(title, style: theme.textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                  onPressed: () => context.go('/capture'),
                  child: Text(t.result.cta),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
