import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/classify/application/screening_service.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/vision/domain/pose_alignment.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';

void main() {
  const sut = ScreeningService();

  NormalizedLandmark mark(BodyLandmarkType type, double x, double y) =>
      NormalizedLandmark(type: type, x: x, y: y, visibility: 0.9);

  /// Cuerpo de frente con proporciones de adulto promedio.
  DetectedPose body() => DetectedPose(
    score: 0.9,
    landmarks: [
      mark(BodyLandmarkType.nose, 0.5, 0.10),
      mark(BodyLandmarkType.leftShoulder, 0.35, 0.22),
      mark(BodyLandmarkType.rightShoulder, 0.65, 0.22),
      mark(BodyLandmarkType.leftElbow, 0.30, 0.40),
      mark(BodyLandmarkType.rightElbow, 0.70, 0.40),
      mark(BodyLandmarkType.leftWrist, 0.28, 0.55),
      mark(BodyLandmarkType.rightWrist, 0.72, 0.55),
      mark(BodyLandmarkType.leftHip, 0.40, 0.55),
      mark(BodyLandmarkType.rightHip, 0.60, 0.55),
      mark(BodyLandmarkType.leftAnkle, 0.43, 0.95),
      mark(BodyLandmarkType.rightAnkle, 0.57, 0.95),
    ],
  );

  PoseAnalysis analysis({
    PoseQuality quality = PoseQuality.usableForTechnicalChecks,
    AlignmentHint? alignment = AlignmentHint.ok,
    bool withPose = true,
  }) => PoseAnalysis(
    quality: quality,
    imageWidth: 480,
    imageHeight: 640,
    processingTime: Duration.zero,
    pose: withPose ? body() : null,
    alignment: alignment,
  );

  ScreeningAbstentionReason reasonOf(ScreeningOutcome outcome) =>
      (outcome as ScreeningAbstention).reason;

  test('pose no utilizable se abstiene por la pose', () {
    final outcome = sut.evaluate(
      analysis(quality: PoseQuality.noPersonDetected),
    );
    expect(reasonOf(outcome), ScreeningAbstentionReason.poseNotUsable);
  });

  test('posición fuera de la guía se abstiene por alineación', () {
    final outcome = sut.evaluate(analysis(alignment: AlignmentHint.tooFar));
    expect(reasonOf(outcome), ScreeningAbstentionReason.alignmentFailed);
  });

  test('sin pose ni datos no hay nada que medir', () {
    expect(
      reasonOf(sut.evaluate(analysis(withPose: false))),
      ScreeningAbstentionReason.poseNotUsable,
    );
  });

  test('la foto sola ya da un WHtR estimado, sin pedir datos', () {
    final outcome = sut.evaluate(analysis());
    final result = (outcome as ScreeningPrediction).result;
    final whtr = result.waistToHeight;
    expect(whtr, isNotNull);
    expect(whtr, inInclusiveRange(0.45, 0.65));
    expect(result.bmi, isNull);
    expect(result.band, isNull);
  });

  test('con peso y estatura suma el IMC real al WHtR', () {
    final outcome = sut.evaluate(analysis(), heightCm: 170, weightKg: 70);
    final result = (outcome as ScreeningPrediction).result;
    expect(result.bmi, closeTo(24.22, 0.01));
    expect(result.band, BmiBand.normal);
    expect(result.margin, isNull);
    expect(result.waistToHeight, isNotNull);
  });
}
