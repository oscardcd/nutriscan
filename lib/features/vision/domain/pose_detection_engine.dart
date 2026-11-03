import 'dart:typed_data';

import 'pose_analysis.dart';

class DetectedPerson {
  DetectedPerson({
    required this.score,
    required List<NormalizedLandmark> landmarks,
  }) : landmarks = List.unmodifiable(landmarks);

  final double score;
  final List<NormalizedLandmark> landmarks;
}

abstract interface class PoseDetectionEngine {
  Future<void> initialize();

  Future<List<DetectedPerson>> detect(Uint8List normalizedJpeg);

  Future<void> dispose();
}
