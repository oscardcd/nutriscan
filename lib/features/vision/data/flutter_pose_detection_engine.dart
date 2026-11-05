import 'dart:typed_data';

import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;

import '../domain/pose_analysis.dart';
import '../domain/pose_detection_engine.dart';

class FlutterPoseDetectionEngine implements PoseDetectionEngine {
  final pose.NpuPoseDetector _detector = pose.NpuPoseDetector(
    config: const pose.PoseDetectorConfig(
      mode: pose.DetectionMode.accurate,
      maxPoses: 5,
      minConfidence: 0.0,
    ),
  );
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await _detector.initialize();
    _initialized = true;
  }

  @override
  Future<List<DetectedPerson>> detect(Uint8List normalizedJpeg) async {
    if (!_initialized) {
      throw const VisionException(VisionFailure.detectorNotInitialized);
    }

    final result = await _detector.detectPose(normalizedJpeg);
    return result.poses
        .map((poseResult) {
          if (poseResult.landmarks.length != pose.LandmarkType.count) {
            throw const VisionException(VisionFailure.invalidDetectorOutput);
          }
          return DetectedPerson(
            score: poseResult.score,
            landmarks: [
              _landmark(
                poseResult,
                pose.LandmarkType.nose,
                BodyLandmarkType.nose,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.leftShoulder,
                BodyLandmarkType.leftShoulder,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.rightShoulder,
                BodyLandmarkType.rightShoulder,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.leftHip,
                BodyLandmarkType.leftHip,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.rightHip,
                BodyLandmarkType.rightHip,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.leftAnkle,
                BodyLandmarkType.leftAnkle,
              ),
              _landmark(
                poseResult,
                pose.LandmarkType.rightAnkle,
                BodyLandmarkType.rightAnkle,
              ),
            ],
          );
        })
        .toList(growable: false);
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
    await pose.PoseDetectorPlatform.instance.dispose();
  }

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
}
