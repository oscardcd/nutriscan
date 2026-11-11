import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;

import '../domain/pose_alignment.dart';
import '../domain/pose_analysis.dart';
import '../domain/pose_detection_engine.dart';
import 'flutter_pose_detection_engine.dart';
import 'pose_image_preprocessor.dart';

class PoseAnalysisService {
  PoseAnalysisService({
    PoseDetectionEngine? engine,
    this.evaluator = const PoseAlignmentEvaluator(),
    this.timeout = const Duration(seconds: 20),
  }) : _engine = engine ?? FlutterPoseDetectionEngine();

  static const _minimumPoseConfidence = 0.35;
  static const _minimumLandmarkVisibility = 0.35;
  static const _landmarkCoordinateTolerance = 0.05;
  static const _requiredBodyLandmarks = {
    BodyLandmarkType.leftShoulder,
    BodyLandmarkType.rightShoulder,
    BodyLandmarkType.leftHip,
    BodyLandmarkType.rightHip,
    BodyLandmarkType.leftAnkle,
    BodyLandmarkType.rightAnkle,
  };

  final PoseDetectionEngine _engine;
  final PoseAlignmentEvaluator evaluator;
  final Duration timeout;
  // shortcut: el plugin no cancela inferencias; tras un timeout el servicio
  // sigue ocupado hasta que el futuro nativo complete.
  Future<PoseAnalysis>? _pendingAnalysis;
  bool _initialized = false;
  bool _disposed = false;

  Future<void> initialize() async {
    if (_disposed) {
      throw const VisionException(VisionFailure.detectorNotInitialized);
    }
    if (_initialized) return;

    try {
      await _engine.initialize().timeout(timeout);
      _initialized = true;
    } on TimeoutException {
      throw const VisionException(VisionFailure.timedOut);
    } on pose.DetectionError catch (error) {
      throw VisionException(_failureForDetectionCode(error.code));
    } on PlatformException {
      throw const VisionException(VisionFailure.modelUnavailable);
    } on MissingPluginException {
      throw const VisionException(VisionFailure.unsupportedPlatform);
    }
  }

  Future<PoseAnalysis> analyze(Uint8List imageBytes) async {
    if (!_initialized || _disposed) {
      throw const VisionException(VisionFailure.detectorNotInitialized);
    }
    if (_pendingAnalysis != null) {
      throw const VisionException(VisionFailure.analysisInProgress);
    }
    if (imageBytes.length > maxPoseImageBytes) {
      throw const VisionException(VisionFailure.imageTooLarge);
    }

    final operation = _analyze(imageBytes);
    _pendingAnalysis = operation;
    unawaited(
      operation.then<void>(
        (_) => _clearPending(operation),
        onError: (Object _, StackTrace stackTrace) {
          _clearPending(operation);
        },
      ),
    );

    try {
      return await operation.timeout(timeout);
    } on TimeoutException {
      throw const VisionException(VisionFailure.timedOut);
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _initialized = false;
    await _engine.dispose();
  }

  Future<PoseAnalysis> _analyze(Uint8List imageBytes) async {
    final stopwatch = Stopwatch()..start();
    try {
      final prepared = await compute(preparePoseImage, imageBytes);
      final preparationFailure = prepared.failure;
      if (preparationFailure != null) {
        throw VisionException(
          preparationFailure == PoseImagePreparationFailure.imageTooLarge
              ? VisionFailure.imageTooLarge
              : VisionFailure.invalidImage,
        );
      }

      final normalizedJpeg = prepared.bytes;
      if (normalizedJpeg == null ||
          prepared.width <= 0 ||
          prepared.height <= 0) {
        throw const VisionException(VisionFailure.invalidImage);
      }

      final people = await _engine.detect(normalizedJpeg);
      final elapsed = stopwatch.elapsed;
      final detectedPose = people.length == 1
          ? _validatedPose(people.single)
          : null;
      final quality = _qualityFor(people, detectedPose);
      return PoseAnalysis(
        quality: quality,
        imageWidth: prepared.width,
        imageHeight: prepared.height,
        processingTime: elapsed,
        pose: detectedPose,
        alignment: detectedPose == null
            ? null
            : evaluator.evaluate(detectedPose),
      );
    } on VisionException {
      rethrow;
    } on pose.DetectionError catch (error) {
      throw VisionException(_failureForDetectionCode(error.code));
    } on PlatformException {
      throw const VisionException(VisionFailure.processingFailed);
    } on MissingPluginException {
      throw const VisionException(VisionFailure.unsupportedPlatform);
    }
  }

  PoseQuality _qualityFor(
    List<DetectedPerson> people,
    DetectedPose? detectedPose,
  ) {
    if (people.isEmpty) return PoseQuality.noPersonDetected;
    if (people.length > 1) return PoseQuality.multiplePeopleDetected;

    final pose = detectedPose!;
    if (pose.score < _minimumPoseConfidence) {
      return PoseQuality.lowPoseConfidence;
    }
    if (_requiredBodyLandmarks.any((type) {
      final landmark = pose.landmark(type);
      return landmark.visibility < _minimumLandmarkVisibility ||
          landmark.x < 0 ||
          landmark.x > 1 ||
          landmark.y < 0 ||
          landmark.y > 1;
    })) {
      return PoseQuality.incompleteBody;
    }
    return PoseQuality.usableForTechnicalChecks;
  }

  DetectedPose _validatedPose(DetectedPerson person) {
    if (!person.score.isFinite || person.score < 0 || person.score > 1) {
      throw const VisionException(VisionFailure.invalidDetectorOutput);
    }

    final landmarks = <BodyLandmarkType, NormalizedLandmark>{};
    for (final landmark in person.landmarks) {
      if (!landmark.x.isFinite ||
          !landmark.y.isFinite ||
          !landmark.visibility.isFinite ||
          // Fuera del encuadre por poco es normal en cuerpos al borde; solo
          // se tolera un margen y se reporta como cuerpo incompleto.
          landmark.x < -_landmarkCoordinateTolerance ||
          landmark.x > 1 + _landmarkCoordinateTolerance ||
          landmark.y < -_landmarkCoordinateTolerance ||
          landmark.y > 1 + _landmarkCoordinateTolerance ||
          landmark.visibility < 0 ||
          landmark.visibility > 1 ||
          landmarks.containsKey(landmark.type)) {
        throw const VisionException(VisionFailure.invalidDetectorOutput);
      }
      landmarks[landmark.type] = landmark;
    }
    if (!_requiredBodyLandmarks.every(landmarks.containsKey)) {
      throw const VisionException(VisionFailure.invalidDetectorOutput);
    }

    return DetectedPose(
      score: person.score,
      landmarks: landmarks.values.toList(),
    );
  }

  void _clearPending(Future<PoseAnalysis> operation) {
    if (identical(_pendingAnalysis, operation)) _pendingAnalysis = null;
  }

  VisionFailure _failureForDetectionCode(
    pose.DetectionErrorCode code,
  ) => switch (code) {
    pose.DetectionErrorCode.invalidImageFormat => VisionFailure.invalidImage,
    pose.DetectionErrorCode.modelLoadFailed => VisionFailure.modelUnavailable,
    pose.DetectionErrorCode.platformNotSupported =>
      VisionFailure.unsupportedPlatform,
    pose.DetectionErrorCode.outOfMemory => VisionFailure.imageTooLarge,
    pose.DetectionErrorCode.notInitialized =>
      VisionFailure.detectorNotInitialized,
    _ => VisionFailure.processingFailed,
  };
}
