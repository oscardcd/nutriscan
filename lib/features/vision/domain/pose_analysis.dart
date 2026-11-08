enum PoseQuality {
  usableForTechnicalChecks,
  noPersonDetected,
  multiplePeopleDetected,
  lowPoseConfidence,
  incompleteBody,
}

enum BodyLandmarkType {
  nose,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftHip,
  rightHip,
  leftAnkle,
  rightAnkle,
}

class NormalizedLandmark {
  const NormalizedLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.visibility,
  });

  final BodyLandmarkType type;
  final double x;
  final double y;
  final double visibility;
}

class DetectedPose {
  DetectedPose({
    required this.score,
    required List<NormalizedLandmark> landmarks,
  }) : landmarks = List.unmodifiable(landmarks);

  final double score;
  final List<NormalizedLandmark> landmarks;

  NormalizedLandmark landmark(BodyLandmarkType type) =>
      landmarks.firstWhere((landmark) => landmark.type == type);
}

class PoseAnalysis {
  PoseAnalysis({
    required this.quality,
    required this.imageWidth,
    required this.imageHeight,
    required this.processingTime,
    this.pose,
  });

  final PoseQuality quality;
  final int imageWidth;
  final int imageHeight;
  final Duration processingTime;
  final DetectedPose? pose;
}

enum VisionFailure {
  invalidImage,
  imageTooLarge,
  unsupportedPlatform,
  modelUnavailable,
  processingFailed,
  timedOut,
  detectorNotInitialized,
  analysisInProgress,
  invalidDetectorOutput,
}

class VisionException implements Exception {
  const VisionException(this.failure);

  final VisionFailure failure;
}
