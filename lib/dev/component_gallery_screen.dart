import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/widgets/bmi_band_chip.dart';
import '../../core/theme/widgets/bmi_range_gauge.dart';
import '../../core/theme/widgets/medical_disclaimer.dart';
import '../../core/ui/ui.dart';
import '../../features/classify/domain/bmi_band.dart';

/// Galería de componentes del design system. Sin datos reales.
class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  bool consent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Componentes')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          const AppHeader(
            title: 'NutriScan',
            subtitle: 'Inicio',
            pillText: '100% On-Device',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: MetricTile(
              label: 'IMC estimado',
              value: '27.4',
              unit: 'kg/m²',
              caption: '±1.8',
              trailing: BmiBandChip(band: classifyBmi(27.4)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: BmiRangeGauge(bmi: 27.4),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Confianza'),
                const SizedBox(height: AppSpacing.sm),
                ConfidenceMeter(
                  level: ConfidenceLevel.high,
                  label: 'Confianza alta',
                ),
                const SizedBox(height: AppSpacing.md),
                const SectionLabel('Índices'),
                IndexTile(
                  icon: Icons.straighten,
                  label: 'Cintura-Altura (WHtR)',
                  value: '0.53',
                  description: 'Distribución abdominal moderada',
                ),
                const IndexTile(
                  icon: Icons.motion_photos_on,
                  label: 'Redondez Corporal (BRI)',
                  value: '3.8',
                  description: 'Morfología dentro de parámetros',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Criterios de escaneo'),
                const SizedBox(height: AppSpacing.sm),
                const ScanCriterion(label: 'Cuerpo completo'),
                const ScanCriterion(label: 'A 2 metros'),
                const ScanCriterion(
                  label: 'Evitar ropa holgada',
                  icon: Icons.info_outline,
                  ok: false,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    HintChip(
                      label: 'Galería',
                      icon: Icons.photo_library_outlined,
                    ),
                    HintChip(label: '3 seg', icon: Icons.timer_outlined),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ConsentCheckbox(
            prefix: 'Entiendo que es una ',
            highlight: 'herramienta de cribado preliminar',
            suffix: ' y no un diagnóstico médico.',
            value: consent,
            onChanged: (v) => setState(() => consent = v),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () {},
            child: const Text('Comenzar evaluación'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: () {}, child: const Text('Ver historial')),
          const SizedBox(height: AppSpacing.md),
          const MedicalDisclaimer(),
          const SizedBox(height: AppSpacing.md),
          const SizedBox(
            height: 180,
            child: EmptyState(
              icon: Icons.show_chart,
              title: 'Aún no hay mediciones',
              message: 'Tu primera medición iniciará el seguimiento.',
            ),
          ),
        ],
      ),
    );
  }
}
