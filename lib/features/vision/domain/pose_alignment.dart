import 'dart:math' as math;

import 'pose_analysis.dart';

/// Qué corregir para la foto. Se muestra un solo mensaje a la vez: el primer
/// check que falla, en orden de utilidad para el usuario.
enum AlignmentHint {
  /// Posición correcta: no hay nada que corregir.
  ok,
  incompleteBody,
  tooFar,
  tooClose,
  notCentered,
  tilted,
  notFrontal,
  armsCoveringTorso,
}

/// Checks geométricos sobre los landmarks normalizados. Dart puro, sin ML.
class PoseAlignmentEvaluator {
  const PoseAlignmentEvaluator();

  /// Alto del cuerpo (nariz → tobillos) en fracción del alto del frame.
  static const double minBodyHeight = 0.75;
  static const double maxBodyHeight = 0.95;

  /// Distancia máxima de la cadera al centro horizontal.
  static const double maxCenterOffset = 0.05;

  static const double maxTiltDegrees = 5;

  /// Hombros / caderas por debajo de esto indica cuerpo de perfil.
  static const double minShoulderHipRatio = 1.15;

  static const double minVisibility = 0.5;

  /// Los siete puntos que deben verse para poder validar la pose.
  static const List<BodyLandmarkType> required = [
    BodyLandmarkType.nose,
    BodyLandmarkType.leftShoulder,
    BodyLandmarkType.rightShoulder,
    BodyLandmarkType.leftHip,
    BodyLandmarkType.rightHip,
    BodyLandmarkType.leftAnkle,
    BodyLandmarkType.rightAnkle,
  ];

  /// [AlignmentHint.ok] cuando la posición es correcta.
  AlignmentHint evaluate(DetectedPose pose) {
    final byType = {
      for (final landmark in pose.landmarks) landmark.type: landmark,
    };
    NormalizedLandmark? at(BodyLandmarkType type) => byType[type];

    for (final type in required) {
      if ((at(type)?.visibility ?? 0) < minVisibility) {
        return AlignmentHint.incompleteBody;
      }
    }

    final nose = at(BodyLandmarkType.nose)!;
    final leftShoulder = at(BodyLandmarkType.leftShoulder)!;
    final rightShoulder = at(BodyLandmarkType.rightShoulder)!;
    final leftHip = at(BodyLandmarkType.leftHip)!;
    final rightHip = at(BodyLandmarkType.rightHip)!;
    final leftAnkle = at(BodyLandmarkType.leftAnkle)!;
    final rightAnkle = at(BodyLandmarkType.rightAnkle)!;

    final bodyHeight = math.max(leftAnkle.y, rightAnkle.y) - nose.y;
    if (bodyHeight < minBodyHeight) return AlignmentHint.tooFar;
    if (bodyHeight > maxBodyHeight) return AlignmentHint.tooClose;

    final hipX = (leftHip.x + rightHip.x) / 2;
    if ((hipX - 0.5).abs() > maxCenterOffset) return AlignmentHint.notCentered;

    if (_tiltDegrees(leftShoulder, rightShoulder) > maxTiltDegrees ||
        _tiltDegrees(leftHip, rightHip) > maxTiltDegrees) {
      return AlignmentHint.tilted;
    }

    final shoulderWidth = (leftShoulder.x - rightShoulder.x).abs();
    final hipWidth = (leftHip.x - rightHip.x).abs();
    if (hipWidth > 0 && shoulderWidth / hipWidth < minShoulderHipRatio) {
      return AlignmentHint.notFrontal;
    }

    final torsoLeft = math.min(
      math.min(leftShoulder.x, rightShoulder.x),
      math.min(leftHip.x, rightHip.x),
    );
    final torsoRight = math.max(
      math.max(leftShoulder.x, rightShoulder.x),
      math.max(leftHip.x, rightHip.x),
    );
    for (final wrist in [
      at(BodyLandmarkType.leftWrist),
      at(BodyLandmarkType.rightWrist),
    ]) {
      // La muñeca solo molesta si se ve: si está oculta no hay nada que decir.
      final visible = (wrist?.visibility ?? 0) >= minVisibility;
      if (visible && wrist!.x > torsoLeft && wrist.x < torsoRight) {
        return AlignmentHint.armsCoveringTorso;
      }
    }

    return AlignmentHint.ok;
  }

  /// Ángulo de la línea que une dos landmarks respecto a la horizontal.
  double _tiltDegrees(NormalizedLandmark a, NormalizedLandmark b) {
    final dx = (b.x - a.x).abs();
    final dy = (b.y - a.y).abs();
    if (dx == 0) return 90;
    return math.atan2(dy, dx) * 180 / math.pi;
  }
}

/// Evita que el mensaje cambie con cada frame inestable: un hint nuevo debe
/// repetirse [frames] veces seguidas antes de reemplazar al actual.
class AlignmentStabilizer {
  AlignmentStabilizer({this.frames = 3}) : assert(frames > 0);

  final int frames;

  AlignmentHint? _current;
  AlignmentHint? _pending;
  int _pendingFrames = 0;

  AlignmentHint? get current => _current;

  AlignmentHint? update(AlignmentHint? hint) {
    if (hint == _current) {
      _pending = null;
      _pendingFrames = 0;
      return _current;
    }
    if (hint == _pending) {
      _pendingFrames++;
    } else {
      _pending = hint;
      _pendingFrames = 1;
    }
    if (_pendingFrames >= frames) {
      _current = hint;
      _pending = null;
      _pendingFrames = 0;
    }
    return _current;
  }

  void reset() {
    _current = null;
    _pending = null;
    _pendingFrames = 0;
  }
}
