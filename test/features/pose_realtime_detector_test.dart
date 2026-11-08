import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/capture/data/capture_camera.dart';
import 'package:nutriscan/features/vision/data/pose_realtime_detector.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';

void main() {
  final frame = CameraFrame(
    planes: [
      CameraFramePlane(
        bytes: Uint8List(4),
        bytesPerRow: 2,
        bytesPerPixel: 1,
      ),
    ],
    width: 640,
    height: 480,
    rotationDegrees: 90,
    format: 'bgra8888',
  );

  test('no procesa frames antes de inicializar', () async {
    final detector = _FakePoseDetector();
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: Duration.zero,
    );

    expect(await sut.process(frame), isNull);
    expect(detector.processFrameCalls, 0);
  });

  test('mapea la pose detectada a los puntos del dominio que usamos', () async {
    final detector = _FakePoseDetector()..result = _resultWithPose();
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: Duration.zero,
    );
    await sut.initialize();

    final pose = await sut.process(frame);

    expect(pose, isNotNull);
    expect(pose!.landmarks, hasLength(11));
    expect(pose.score, 0.9);
    expect(pose.landmark(BodyLandmarkType.nose).y, closeTo(0.1, 1e-9));
    expect(pose.landmark(BodyLandmarkType.rightAnkle).x, closeTo(0.55, 1e-9));
    expect(detector.lastRotation, 90);
    expect(detector.lastFormat, 'bgra8888');
  });

  test('devuelve null cuando no hay persona', () async {
    final detector = _FakePoseDetector()
      ..result = pose.PoseResult.empty(
        processingTimeMs: 1,
        accelerationMode: pose.AccelerationMode.cpu,
        imageWidth: 640,
        imageHeight: 480,
      );
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: Duration.zero,
    );
    await sut.initialize();

    expect(await sut.process(frame), isNull);
  });

  test('descarta frames dentro del intervalo mínimo', () async {
    final detector = _FakePoseDetector()..result = _resultWithPose();
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: const Duration(hours: 1),
    );
    await sut.initialize();

    expect(await sut.process(frame), isNotNull);
    expect(await sut.process(frame), isNull);
    expect(detector.processFrameCalls, 1);
  });

  test('mantiene la posición de un punto que MediaPipe pierde', () async {
    final detector = _FakePoseDetector()..result = _resultWithPose();
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: Duration.zero,
      smoothing: 0,
    );
    await sut.initialize();

    final first = await sut.process(frame);
    final wristBefore = first!.landmark(BodyLandmarkType.leftWrist);

    // MediaPipe devuelve (0,0) con confianza baja: la muñeca no debe saltar.
    detector.result = _resultWithHiddenLeftWrist();
    final second = await sut.process(frame);
    final wristAfter = second!.landmark(BodyLandmarkType.leftWrist);

    expect(wristAfter.x, closeTo(wristBefore.x, 1e-9));
    expect(wristAfter.y, closeTo(wristBefore.y, 1e-9));
  });

  test('descarta frames mientras el detector está ocupado', () async {
    final detector = _FakePoseDetector()..result = _resultWithPose();
    detector.gate = Completer<void>();
    final sut = PoseRealtimeDetector(
      detector: detector,
      minInterval: Duration.zero,
    );
    await sut.initialize();

    final inFlight = sut.process(frame);
    await Future<void>.delayed(Duration.zero);
    expect(await sut.process(frame), isNull);

    detector.gate!.complete();
    expect(await inFlight, isNotNull);
    expect(detector.processFrameCalls, 1);
  });
}

pose.PoseResult _resultWithPose() {
  final landmarks = [
    for (final type in pose.LandmarkType.values)
      pose.PoseLandmark(type: type, x: 0.5, y: 0.5, visibility: 0.9),
  ]..[pose.LandmarkType.nose.value] = const pose.PoseLandmark(
    type: pose.LandmarkType.nose,
    x: 0.5,
    y: 0.1,
    visibility: 0.9,
  );
  landmarks[pose.LandmarkType.rightAnkle.value] = const pose.PoseLandmark(
    type: pose.LandmarkType.rightAnkle,
    x: 0.55,
    y: 0.9,
    visibility: 0.9,
  );
  return pose.PoseResult(
    poses: [pose.Pose(landmarks: landmarks, score: 0.9)],
    processingTimeMs: 31,
    accelerationMode: pose.AccelerationMode.cpu,
    timestamp: DateTime(2026),
    imageWidth: 640,
    imageHeight: 480,
  );
}

pose.PoseResult _resultWithHiddenLeftWrist() {
  final base = _resultWithPose();
  return pose.PoseResult(
    poses: [
      pose.Pose(
        score: base.poses.first.score,
        landmarks: [
          for (final landmark in base.poses.first.landmarks)
            if (landmark.type == pose.LandmarkType.leftWrist)
              const pose.PoseLandmark(
                type: pose.LandmarkType.leftWrist,
                x: 0,
                y: 0,
                visibility: 0.1,
              )
            else
              landmark,
        ],
      ),
    ],
    processingTimeMs: 31,
    accelerationMode: pose.AccelerationMode.cpu,
    timestamp: DateTime(2026),
    imageWidth: 640,
    imageHeight: 480,
  );
}

class _FakePoseDetector implements pose.NpuPoseDetector {
  pose.PoseResult? result;
  Completer<void>? gate;
  int processFrameCalls = 0;
  int? lastRotation;
  String? lastFormat;

  @override
  Future<pose.PoseResult> processFrame({
    required List<Map<String, dynamic>> planes,
    required int width,
    required int height,
    required String format,
    int rotation = 0,
  }) async {
    processFrameCalls++;
    lastRotation = rotation;
    lastFormat = format;
    final pending = gate;
    if (pending != null) await pending.future;
    return result!;
  }

  @override
  Future<pose.AccelerationMode> initialize() async =>
      pose.AccelerationMode.cpu;

  @override
  void dispose() {}

  @override
  pose.PoseDetectorConfig get config => const pose.PoseDetectorConfig();

  @override
  bool get isInitialized => true;

  @override
  pose.AccelerationMode get accelerationMode => pose.AccelerationMode.cpu;

  @override
  Future<pose.PoseResult> detectPose(Uint8List imageBytes) =>
      throw UnimplementedError();

  @override
  Future<pose.PoseResult> detectPoseFromFile(String imagePath) =>
      throw UnimplementedError();

  @override
  Future<void> updateConfig(pose.PoseDetectorConfig config) async {}

  @override
  Stream<pose.FrameResult> startCameraDetection() => const Stream.empty();

  @override
  Future<void> stopCameraDetection() async {}

  @override
  Future<pose.VideoAnalysisResult> analyzeVideo(
    String videoPath, {
    int frameInterval = 1,
  }) => throw UnimplementedError();

  @override
  Stream<pose.VideoAnalysisProgress> get videoAnalysisProgress =>
      const Stream.empty();

  @override
  Future<void> cancelVideoAnalysis() async {}
}
