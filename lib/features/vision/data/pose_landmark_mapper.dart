import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;

import '../domain/pose_analysis.dart';

const _landmarkTypes = <pose.LandmarkType, BodyLandmarkType>{
  pose.LandmarkType.nose: BodyLandmarkType.nose,
  pose.LandmarkType.leftShoulder: BodyLandmarkType.leftShoulder,
  pose.LandmarkType.rightShoulder: BodyLandmarkType.rightShoulder,
  pose.LandmarkType.leftHip: BodyLandmarkType.leftHip,
  pose.LandmarkType.rightHip: BodyLandmarkType.rightHip,
  pose.LandmarkType.leftAnkle: BodyLandmarkType.leftAnkle,
  pose.LandmarkType.rightAnkle: BodyLandmarkType.rightAnkle,
};

/// Convierte las 33 landmarks del plugin en los 7 puntos que usa el dominio.
List<NormalizedLandmark> mapBodyLandmarks(pose.Pose detectedPose) => [
  for (final entry in _landmarkTypes.entries)
    _landmark(detectedPose, entry.key, entry.value),
];

NormalizedLandmark _landmark(
  pose.Pose detectedPose,
  pose.LandmarkType pluginType,
  BodyLandmarkType domainType,
) {
  final landmark = detectedPose.getLandmark(pluginType);
  return NormalizedLandmark(
    type: domainType,
    x: landmark.x,
    y: landmark.y,
    visibility: landmark.visibility,
  );
}
