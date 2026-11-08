import '../../vision/domain/body_proportions.dart';
import '../../vision/domain/pose_alignment.dart';
import '../../vision/domain/pose_analysis.dart';
import '../domain/bmi_band.dart';
import '../domain/screening_outcome.dart';
import '../domain/screening_result.dart';

/// Caso de uso de cribado: captura → controles de calidad → índice de forma.
///
/// El WHtR sale de las proporciones de la propia foto, así que **toda captura
/// válida produce un resultado** sin pedir datos. El IMC es un extra opcional:
/// solo se calcula si la persona declara peso y estatura (cálculo directo, no
/// estimación). Lo que no se puede medir se deja nulo, nunca se inventa.
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

    final pose = analysis.pose;
    final waistToHeight = pose == null ? null : estimateWaistToHeight(pose);
    final bmi = heightCm == null || weightKg == null
        ? null
        : bmiFrom(heightCm, weightKg);
    if (waistToHeight == null && bmi == null) {
      return const ScreeningAbstention(ScreeningAbstentionReason.poseNotUsable);
    }

    // shortcut: WHtR geométrico + IMC declarado. BRI y RFM llegan con el
    // modelo de F3; este es el único punto que debe cambiar.
    return ScreeningPrediction(
      ScreeningResult(bmi: bmi, waistToHeight: waistToHeight),
    );
  }
}
