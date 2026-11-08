import '../../vision/domain/pose_alignment.dart';
import '../../vision/domain/pose_analysis.dart';
import '../domain/bmi_band.dart';
import '../domain/screening_outcome.dart';
import '../domain/screening_result.dart';

/// Caso de uso de cribado: captura → controles de calidad → IMC.
///
/// El IMC se calcula directo con el peso y la estatura declarados, así que es
/// real y no una estimación. Los índices antropométricos siguen sin existir
/// (F3 pendiente): se omiten en vez de inventarlos.
class ScreeningService {
  const ScreeningService();

  ScreeningOutcome evaluate(
    PoseAnalysis analysis, {
    double? heightCm,
    double? weightKg,
  }) {
    if (analysis.quality != PoseQuality.usableForTechnicalChecks) {
      return const ScreeningAbstention(ScreeningAbstentionReason.poseNotUsable);
    }
    final hint = analysis.alignment;
    if (hint != null && hint != AlignmentHint.ok) {
      return const ScreeningAbstention(
        ScreeningAbstentionReason.alignmentFailed,
      );
    }
    if (heightCm == null || weightKg == null) {
      return const ScreeningAbstention(ScreeningAbstentionReason.noBodyData);
    }
    // shortcut: solo IMC. Los índices (WHtR/BRI/RFM) llegan con el modelo F3;
    // este es el único punto que debe cambiar.
    return ScreeningPrediction(
      ScreeningResult(bmi: bmiFrom(heightCm, weightKg)),
    );
  }
}
