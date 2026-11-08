import 'package:flutter/material.dart';

import '../domain/pose_analysis.dart';

/// Dibuja la silueta objetivo (fantasma) y, si hay pose detectada, el
/// esqueleto del usuario encima del preview.
///
/// Las coordenadas son normalizadas (0..1) sobre el frame, así que se mapean
/// directo al tamaño del preview: el frame es 3:4 y el preview también.
class PoseGuidePainter extends CustomPainter {
  const PoseGuidePainter({
    required this.pose,
    this.targetColor = const Color(0x8CFFFFFF),
    this.detectedColor = const Color(0xFF3DDC84),
  });

  final DetectedPose? pose;
  final Color targetColor;
  final Color detectedColor;

  /// Pose de referencia: cuerpo completo, frontal y centrado en el encuadre.
  static const target = <BodyLandmarkType, Offset>{
    BodyLandmarkType.nose: Offset(0.50, 0.28),
    BodyLandmarkType.leftShoulder: Offset(0.40, 0.36),
    BodyLandmarkType.rightShoulder: Offset(0.60, 0.36),
    BodyLandmarkType.leftElbow: Offset(0.31, 0.45),
    BodyLandmarkType.rightElbow: Offset(0.69, 0.45),
    BodyLandmarkType.leftWrist: Offset(0.23, 0.53),
    BodyLandmarkType.rightWrist: Offset(0.77, 0.53),
    BodyLandmarkType.leftHip: Offset(0.42, 0.57),
    BodyLandmarkType.rightHip: Offset(0.58, 0.57),
    BodyLandmarkType.leftAnkle: Offset(0.38, 0.90),
    BodyLandmarkType.rightAnkle: Offset(0.62, 0.90),
  };

  static const _bones = <(BodyLandmarkType, BodyLandmarkType)>[
    (BodyLandmarkType.nose, BodyLandmarkType.leftShoulder),
    (BodyLandmarkType.nose, BodyLandmarkType.rightShoulder),
    (BodyLandmarkType.leftShoulder, BodyLandmarkType.rightShoulder),
    (BodyLandmarkType.leftShoulder, BodyLandmarkType.leftElbow),
    (BodyLandmarkType.leftElbow, BodyLandmarkType.leftWrist),
    (BodyLandmarkType.rightShoulder, BodyLandmarkType.rightElbow),
    (BodyLandmarkType.rightElbow, BodyLandmarkType.rightWrist),
    (BodyLandmarkType.leftShoulder, BodyLandmarkType.leftHip),
    (BodyLandmarkType.rightShoulder, BodyLandmarkType.rightHip),
    (BodyLandmarkType.leftHip, BodyLandmarkType.rightHip),
    (BodyLandmarkType.leftHip, BodyLandmarkType.leftAnkle),
    (BodyLandmarkType.rightHip, BodyLandmarkType.rightAnkle),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, size, target, targetColor, strokeWidth: 3);

    final pose = this.pose;
    if (pose == null) return;
    _draw(canvas, size, {
      for (final landmark in pose.landmarks)
        // MediaPipe devuelve (0,0) en los puntos que no ve.
        if (landmark.visibility >= 0.3)
          landmark.type: Offset(landmark.x, landmark.y),
    }, detectedColor, strokeWidth: 4);
  }

  void _draw(
    Canvas canvas,
    Size size,
    Map<BodyLandmarkType, Offset> joints,
    Color color, {
    required double strokeWidth,
  }) {
    Offset? toCanvas(BodyLandmarkType type) {
      final point = joints[type];
      if (point == null) return null;
      return Offset(point.dx * size.width, point.dy * size.height);
    }

    final bones = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final dots = Paint()..color = color;

    for (final (from, to) in _bones) {
      final start = toCanvas(from);
      final end = toCanvas(to);
      if (start == null || end == null) continue;
      canvas.drawLine(start, end, bones);
    }
    for (final type in joints.keys) {
      final point = toCanvas(type);
      if (point == null) continue;
      canvas.drawCircle(point, strokeWidth * 1.8, dots);
    }
  }

  @override
  bool shouldRepaint(PoseGuidePainter oldDelegate) =>
      oldDelegate.pose != pose ||
      oldDelegate.targetColor != targetColor ||
      oldDelegate.detectedColor != detectedColor;
}
