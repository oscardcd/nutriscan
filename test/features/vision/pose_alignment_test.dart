import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/vision/domain/pose_alignment.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';

void main() {
  const evaluator = PoseAlignmentEvaluator();

  test('cuerpo completo, centrado y frontal no da hints', () {
    expect(evaluator.evaluate(_pose(_body())), AlignmentHint.ok);
  });

  test('exige los siete puntos visibles', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.rightAnkle)] = _landmark(
      BodyLandmarkType.rightAnkle,
      0.55,
      0.90,
      visibility: 0.2,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.incompleteBody);
  });

  test('detecta que está demasiado lejos', () {
    final body = _body();
    for (final type in [
      BodyLandmarkType.nose,
      BodyLandmarkType.leftShoulder,
      BodyLandmarkType.rightShoulder,
    ]) {
      final old = body[_indexOf(body, type)];
      body[_indexOf(body, type)] = _landmark(
        type,
        old.x,
        old.y + 0.30,
        visibility: old.visibility,
      );
    }

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.tooFar);
  });

  test('detecta que está demasiado cerca', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.nose)] = _landmark(
      BodyLandmarkType.nose,
      0.50,
      0.02,
    );
    body[_indexOf(body, BodyLandmarkType.leftAnkle)] = _landmark(
      BodyLandmarkType.leftAnkle,
      0.45,
      0.99,
    );
    body[_indexOf(body, BodyLandmarkType.rightAnkle)] = _landmark(
      BodyLandmarkType.rightAnkle,
      0.55,
      0.99,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.tooClose);
  });

  test('detecta el cuerpo descentrado', () {
    final shifted = [
      for (final landmark in _body())
        _landmark(
          landmark.type,
          landmark.x + 0.10,
          landmark.y,
          visibility: landmark.visibility,
        ),
    ];

    expect(evaluator.evaluate(_pose(shifted)), AlignmentHint.notCentered);
  });

  test('detecta hombros inclinados', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.rightShoulder)] = _landmark(
      BodyLandmarkType.rightShoulder,
      0.58,
      0.31,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.tilted);
  });

  test('detecta el cuerpo de perfil', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.leftShoulder)] = _landmark(
      BodyLandmarkType.leftShoulder,
      0.47,
      0.25,
    );
    body[_indexOf(body, BodyLandmarkType.rightShoulder)] = _landmark(
      BodyLandmarkType.rightShoulder,
      0.53,
      0.25,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.notFrontal);
  });

  test('detecta brazos pegados al torso', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.leftWrist)] = _landmark(
      BodyLandmarkType.leftWrist,
      0.50,
      0.47,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.armsCoveringTorso);
  });

  test('una muñeca oculta no se evalúa', () {
    final body = _body();
    body[_indexOf(body, BodyLandmarkType.leftWrist)] = _landmark(
      BodyLandmarkType.leftWrist,
      0.50,
      0.47,
      visibility: 0.1,
    );

    expect(evaluator.evaluate(_pose(body)), AlignmentHint.ok);
  });

  group('AlignmentStabilizer', () {
    test('cambia el mensaje tras tres frames iguales', () {
      final sut = AlignmentStabilizer();

      expect(sut.update(AlignmentHint.tooFar), isNull);
      expect(sut.update(AlignmentHint.tooFar), isNull);
      expect(sut.update(AlignmentHint.tooFar), AlignmentHint.tooFar);
    });

    test('un frame distinto no reinicia la cuenta pero sí la corta', () {
      final sut = AlignmentStabilizer();

      sut.update(AlignmentHint.tooFar);
      sut.update(AlignmentHint.tooFar);
      expect(sut.update(AlignmentHint.tilted), isNull);
      expect(sut.update(AlignmentHint.tilted), isNull);
      expect(sut.update(AlignmentHint.tilted), AlignmentHint.tilted);
    });

    test('reset vuelve al estado inicial', () {
      final sut = AlignmentStabilizer();
      sut
        ..update(AlignmentHint.tooFar)
        ..update(AlignmentHint.tooFar)
        ..update(AlignmentHint.tooFar);
      sut.reset();

      expect(sut.update(AlignmentHint.tooFar), isNull);
    });
  });
}

NormalizedLandmark _landmark(
  BodyLandmarkType type,
  double x,
  double y, {
  double visibility = 0.9,
}) => NormalizedLandmark(type: type, x: x, y: y, visibility: visibility);

/// Cuerpo frontal bien encuadrado: 0,80 de alto, cadera en 0,50.
List<NormalizedLandmark> _body() => [
  _landmark(BodyLandmarkType.nose, 0.50, 0.10),
  _landmark(BodyLandmarkType.leftShoulder, 0.42, 0.25),
  _landmark(BodyLandmarkType.rightShoulder, 0.58, 0.25),
  _landmark(BodyLandmarkType.leftElbow, 0.38, 0.36),
  _landmark(BodyLandmarkType.rightElbow, 0.62, 0.36),
  _landmark(BodyLandmarkType.leftWrist, 0.35, 0.47),
  _landmark(BodyLandmarkType.rightWrist, 0.65, 0.47),
  _landmark(BodyLandmarkType.leftHip, 0.44, 0.55),
  _landmark(BodyLandmarkType.rightHip, 0.56, 0.55),
  _landmark(BodyLandmarkType.leftAnkle, 0.45, 0.90),
  _landmark(BodyLandmarkType.rightAnkle, 0.55, 0.90),
];

int _indexOf(List<NormalizedLandmark> landmarks, BodyLandmarkType type) =>
    landmarks.indexWhere((landmark) => landmark.type == type);

DetectedPose _pose(List<NormalizedLandmark> landmarks) =>
    DetectedPose(score: 0.9, landmarks: landmarks);
