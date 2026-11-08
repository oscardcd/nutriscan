import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../data/pose_analysis_service.dart';
import '../domain/pose_analysis.dart';

/// Analiza la foto ya tomada y entrega el resultado sin que el usuario haga nada.
class PhotoAlignmentWatcher extends StatefulWidget {
  const PhotoAlignmentWatcher({
    super.key,
    required this.image,
    required this.onResult,
    this.service,
  });

  final Uint8List image;
  final ValueChanged<PoseAnalysis> onResult;
  final PoseAnalysisService? service;

  @override
  State<PhotoAlignmentWatcher> createState() => _PhotoAlignmentWatcherState();
}

class _PhotoAlignmentWatcherState extends State<PhotoAlignmentWatcher> {
  PoseAnalysisService? _service;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  @override
  void didUpdateWidget(PhotoAlignmentWatcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.image, widget.image)) unawaited(_run());
  }

  Future<void> _run() async {
    final service = _service ??= widget.service ?? PoseAnalysisService();
    try {
      final result = await service.analyze(widget.image);
      if (mounted) widget.onResult(result);
    } catch (_) {
      // Un fallo del detector no debe interrumpir la captura: sin aviso, se sigue.
    }
  }

  @override
  void dispose() {
    // Un servicio inyectado lo cierra quien lo creó: el nativo es compartido.
    if (widget.service == null) unawaited(_service?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
