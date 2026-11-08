import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/ui.dart';
import '../../../i18n/strings.g.dart';
import '../data/pose_analysis_service.dart';
import 'alignment_text.dart';
import '../domain/pose_alignment.dart';
import '../domain/pose_analysis.dart';

/// Diagnóstico temporal para probar el detector de pose en dispositivo real.
/// No alimenta el resultado de cribado; solo muestra calidad y tiempo.
class PoseDebugPanel extends StatefulWidget {
  const PoseDebugPanel({super.key, required this.image, this.service});

  final Uint8List image;
  final PoseAnalysisService? service;

  @override
  State<PoseDebugPanel> createState() => _PoseDebugPanelState();
}

class _PoseDebugPanelState extends State<PoseDebugPanel> {
  PoseAnalysisService? _service;
  PoseAnalysis? _result;
  VisionFailure? _failure;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    // Avisar sin bloquear: la foto ya está tomada, así que se analiza sola.
    unawaited(_run());
  }

  @override
  void didUpdateWidget(PoseDebugPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.image, widget.image)) unawaited(_run());
  }

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _result = null;
      _failure = null;
    });

    final service = _service ??= widget.service ?? PoseAnalysisService();
    try {
      await service.initialize();
      final result = await service.analyze(widget.image);
      if (mounted) setState(() => _result = result);
    } on VisionException catch (error) {
      if (mounted) setState(() => _failure = error.failure);
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  void dispose() {
    unawaited(_service?.dispose());
    super.dispose();
  }

  String _qualityLabel(Translations t, PoseQuality quality) =>
      switch (quality) {
        PoseQuality.usableForTechnicalChecks => t.capture.poseQualityUsable,
        PoseQuality.noPersonDetected => t.capture.poseQualityNoPerson,
        PoseQuality.multiplePeopleDetected => t.capture.poseQualityMultiple,
        PoseQuality.lowPoseConfidence => t.capture.poseQualityLowConfidence,
        PoseQuality.incompleteBody => t.capture.poseQualityIncomplete,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final result = _result;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(t.capture.poseDebugTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.capture.poseDebugHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_running)
            const LinearProgressIndicator()
          else
            OutlinedButton.icon(
              onPressed: _run,
              icon: const Icon(Icons.accessibility_new),
              label: Text(t.capture.poseDebugRun),
            ),
          if (result != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _qualityLabel(t, result.quality),
              style: theme.textTheme.bodyMedium,
            ),
            if (result.alignment case final alignment?) ...[
              Text(
                alignmentReadout(t, alignment).$1,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: alignment == AlignmentHint.ok
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
              ),
              if (alignment != AlignmentHint.ok)
                Text(
                  t.capture.alignmentPhotoWarning,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
            Text(
              '${result.processingTime.inMilliseconds} ms · '
              '${result.imageWidth}×${result.imageHeight} · '
              '${result.pose?.landmarks.length ?? 0} landmarks',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (_failure != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${t.capture.poseDebugFailed}: ${_failure!.name}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
