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
    pose.NpuPoseDetector? detector,
  }) : _detector =
           detector ??
           pose.NpuPoseDetector(config: pose.PoseDetectorConfig.realtime());

  final pose.NpuPoseDetector _detector;
  final Duration minInterval;

  final Stopwatch _clock = Stopwatch()..start();
  Duration? _lastFrameAt;
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
        // CaptureCamera abre el stream en yuv420.
        format: 'yuv420',
        rotation: frame.rotationDegrees,
      );
      if (result.poses.isEmpty) return null;
      return DetectedPose(
        score: result.poses.first.score,
        landmarks: mapBodyLandmarks(result.poses.first),
      );
    } on PlatformException {
      // Frame perdido: el siguiente iteración del stream sigue.
      return null;
    } finally {
      _busy = false;
    }
  }

  void dispose() {
    _ready = false;
    _detector.dispose();
  }
}
