import 'dart:typed_data';

import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;

import '../domain/pose_analysis.dart';
import '../domain/pose_detection_engine.dart';
import 'pose_landmark_mapper.dart';

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
            landmarks: mapBodyLandmarks(poseResult),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
    await pose.PoseDetectorPlatform.instance.dispose();
  }
}
