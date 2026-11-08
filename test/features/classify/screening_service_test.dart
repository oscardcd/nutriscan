import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/classify/application/screening_service.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/vision/domain/pose_alignment.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';

void main() {
  const sut = ScreeningService();

  PoseAnalysis analysis({
    PoseQuality quality = PoseQuality.usableForTechnicalChecks,
    AlignmentHint? alignment = AlignmentHint.ok,
  }) => PoseAnalysis(
    quality: quality,
    imageWidth: 1,
    imageHeight: 1,
    processingTime: Duration.zero,
    alignment: alignment,
  );

  ScreeningAbstentionReason reasonOf(ScreeningOutcome outcome) =>
      (outcome as ScreeningAbstention).reason;

  test('pose no utilizable se abstiene por la pose', () {
    final outcome = sut.evaluate(analysis(quality: PoseQuality.noPersonDetected));
    expect(reasonOf(outcome), ScreeningAbstentionReason.poseNotUsable);
  });

  test('posición fuera de la guía se abstiene por alineación', () {
    final outcome = sut.evaluate(analysis(alignment: AlignmentHint.tooFar));
    expect(reasonOf(outcome), ScreeningAbstentionReason.alignmentFailed);
  });

  test('pose válida sin peso ni estatura se abstiene por falta de datos', () {
    expect(
      reasonOf(sut.evaluate(analysis())),
      ScreeningAbstentionReason.noBodyData,
    );
  });

  test('con peso y estatura calcula el IMC y no inventa índices', () {
    final outcome = sut.evaluate(
      analysis(),
      heightCm: 170,
      weightKg: 70,
    );
    final result = (outcome as ScreeningPrediction).result;
    expect(result.bmi, closeTo(24.22, 0.01));
    expect(result.band, BmiBand.normal);
    expect(result.margin, isNull);
    expect(result.hasAnthropometrics, isFalse);
  });
}
