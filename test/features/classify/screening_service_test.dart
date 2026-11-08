import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/classify/application/screening_service.dart';
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

  test('pose válida y alineada se abstiene por falta de modelo', () {
    expect(reasonOf(sut.evaluate(analysis())), ScreeningAbstentionReason.noModel);
  });
}
