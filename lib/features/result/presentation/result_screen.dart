import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/widgets/bmi_band_chip.dart';
import '../../../core/theme/widgets/bmi_range_gauge.dart';
import '../../../core/theme/widgets/medical_disclaimer.dart';
import '../../../core/ui/ui.dart';
import '../../classify/domain/bmi_band.dart';
import '../../classify/domain/screening_result.dart';
import '../../../i18n/strings.g.dart';

/// Resultado de cribado. Nunca se presenta como diagnóstico.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final ScreeningResult result;

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
              subtitle: t.result.subtitle,
              pillText: t.onDevice.pill,
              onProfileTap: () => context.go('/profile'),
              profileTooltip: t.profile.title,
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
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MetricTile(
                          label: t.result.bmiLabel,
                          value: result.bmi.toStringAsFixed(1),
                          unit: 'kg/m²',
                          trailing: BmiBandChip(band: result.band),
                          caption:
                              '±${result.margin.toStringAsFixed(1)} · '
                              '${t.result.rangeLabel} '
                              '${result.bmiMin.toStringAsFixed(1)} – '
                              '${result.bmiMax.toStringAsFixed(1)}',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BmiRangeGauge(
                          bmi: result.bmi,
                          label: t.result.scaleTitle,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ConfidenceMeter(
                          level: switch (result.confidence) {
                            ScreeningConfidence.low => ConfidenceLevel.low,
                            ScreeningConfidence.medium =>
                              ConfidenceLevel.medium,
                            ScreeningConfidence.high => ConfidenceLevel.high,
                          },
                          label: switch (result.confidence) {
                            ScreeningConfidence.low => t.result.confidenceLow,
                            ScreeningConfidence.medium =>
                              t.result.confidenceMedium,
                            ScreeningConfidence.high => t.result.confidenceHigh,
                          },
                        ),
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
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionLabel(t.result.indicesTitle),
                        IndexTile(
                          icon: Icons.swap_vert_circle_outlined,
                          label: t.result.whtr,
                          value: result.waistToHeight.toStringAsFixed(2),
                          description: t.result.whtrNote,
                        ),
                        IndexTile(
                          icon: Icons.motion_photos_on_outlined,
                          label: t.result.bri,
                          value: result.bodyRoundness.toStringAsFixed(1),
                          description: t.result.briNote,
                        ),
                        IndexTile(
                          icon: Icons.pie_chart_outline,
                          label: t.result.rfm,
                          value:
                              '${result.relativeFatMass.toStringAsFixed(1)}%',
                          description: t.result.rfmNote,
                        ),
                      ],
                    ),
                  ),
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
          Text(
            range,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
