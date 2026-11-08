import 'package:flutter/services.dart';
import 'package:flutter_pose_detection/flutter_pose_detection.dart' as pose;

import '../../capture/data/capture_camera.dart';
import '../domain/pose_analysis.dart';
import 'pose_landmark_mapper.dart';

/// Detector de pose sobre el image stream de la cámara.
///
/// La cámara entrega ~30 fps y la inferencia tarda ~31 ms en el iPhone medido
/// (fase 0), así que descarta frames mientras está ocupado y respeta
/// [minInterval] entre inferencias.
class PoseRealtimeDetector {
  PoseRealtimeDetector({
    this.minInterval = const Duration(milliseconds: 66),
    this.smoothing = 0.4,
    pose.NpuPoseDetector? detector,
  }) : _detector =
           detector ??
           pose.NpuPoseDetector(config: pose.PoseDetectorConfig.realtime());

  final pose.NpuPoseDetector _detector;
  final Duration minInterval;

  /// Peso del frame anterior al mezclar landmarks (0 = sin suavizado).
  final double smoothing;

  final Stopwatch _clock = Stopwatch()..start();
  Duration? _lastFrameAt;
  DetectedPose? _previous;
  final Map<BodyLandmarkType, (NormalizedLandmark, int)> _lastVisible = {};
  int _frameIndex = 0;
  bool _busy = false;
  bool _ready = false;

  bool get isReady => _ready;

  Future<void> initialize() async {
    if (_ready) return;
    await _detector.initialize();
    _ready = true;
  }

  /// `null` si el frame se descartó, no había persona o falló la inferencia.
  Future<DetectedPose?> process(CameraFrame frame) async {
    if (!_ready || _busy) return null;
    final now = _clock.elapsed;
    final lastFrameAt = _lastFrameAt;
    if (lastFrameAt != null && now - lastFrameAt < minInterval) return null;
    _lastFrameAt = now;
    _busy = true;
    try {
      final result = await _detector.processFrame(
        planes: [
          for (final plane in frame.planes)
            {
              'bytes': plane.bytes,
              'bytesPerRow': plane.bytesPerRow,
              'bytesPerPixel': plane.bytesPerPixel,
            },
        ],
        width: frame.width,
        height: frame.height,
        format: frame.format,
        rotation: frame.rotationDegrees,
      );
      if (result.poses.isEmpty) return null;
      _frameIndex++;
      final detected = _keepVisible(
        DetectedPose(
          score: result.poses.first.score,
          landmarks: mapBodyLandmarks(result.poses.first),
        ),
      );
      final previous = _previous;
      _previous = detected;
      return previous == null ? detected : _blend(previous, detected);
    } on PlatformException {
      // Frame perdido: el siguiente iteración del stream sigue.
      return null;
    } finally {
      _busy = false;
    }
  }

  void dispose() {
    _ready = false;
    _previous = null;
    _lastVisible.clear();
    _detector.dispose();
  }

  /// Mezcla con el frame anterior para que el esqueleto no tiemble a 15 fps.
  DetectedPose _blend(DetectedPose previous, DetectedPose next) {
    final before = {for (final landmark in previous.landmarks) landmark.type: landmark};
    return DetectedPose(
      score: next.score,
      landmarks: [
        for (final landmark in next.landmarks)
          if (before[landmark.type] case final old?)
            // Con visibilidad baja el plugin devuelve (0,0): mantener la
            // posición anterior evita que el punto vuele a la esquina.
            if (landmark.visibility < _minBlendVisibility)
              old
            else
              NormalizedLandmark(
                type: landmark.type,
                x: _mix(old.x, landmark.x),
                y: _mix(old.y, landmark.y),
                visibility: _mix(old.visibility, landmark.visibility),
              )
          else
            landmark,
      ],
    );
  }

  /// Un punto que ya se vio se mantiene [keepFrames] frames aunque MediaPipe
  /// baje la confianza (brazos pegados al torso): sin esto parpadea.
  DetectedPose _keepVisible(DetectedPose detected) {
    final landmarks = <NormalizedLandmark>[];
    for (final landmark in detected.landmarks) {
      if (landmark.visibility >= _visibleVisibility) {
        _lastVisible[landmark.type] = (landmark, _frameIndex);
        landmarks.add(landmark);
        continue;
      }
      final held = _lastVisible[landmark.type];
      final stillFresh =
          held != null && _frameIndex - held.$2 <= keepFrames;
      landmarks.add(stillFresh ? held.$1 : landmark);
    }
    return DetectedPose(score: detected.score, landmarks: landmarks);
  }

  static const int keepFrames = 20;
  static const double _visibleVisibility = 0.5;
  static const double _minBlendVisibility = 0.5;

  double _mix(double previous, double next) =>
      next * (1 - smoothing) + previous * smoothing;
}
