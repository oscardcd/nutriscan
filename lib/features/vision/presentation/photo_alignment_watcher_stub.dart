import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../domain/pose_analysis.dart';

/// En web no hay detector local: la foto se acepta sin analizarla.
class PhotoAlignmentWatcher extends StatelessWidget {
  const PhotoAlignmentWatcher({
    super.key,
    required this.image,
    required this.onResult,
    this.service,
  });

  final Uint8List image;
  final ValueChanged<PoseAnalysis> onResult;
  final Object? service;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
