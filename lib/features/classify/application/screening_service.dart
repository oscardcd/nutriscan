import '../../vision/domain/pose_alignment.dart';
import '../../vision/domain/pose_analysis.dart';
import '../domain/screening_outcome.dart';

/// Caso de uso de cribado: captura → controles de calidad → predicción.
///
/// Hoy no hay modelo de estimación (F3 pendiente), así que el servicio se
/// abstiene con un motivo explícito en vez de fabricar un `ScreeningResult`.
class ScreeningService {
  const ScreeningService();

  ScreeningOutcome evaluate(PoseAnalysis analysis) {
    if (analysis.quality != PoseQuality.usableForTechnicalChecks) {
      return const ScreeningAbstention(ScreeningAbstentionReason.poseNotUsable);
    }
    final hint = analysis.alignment;
    if (hint != null && hint != AlignmentHint.ok) {
      return const ScreeningAbstention(
        ScreeningAbstentionReason.alignmentFailed,
      );
    }
    // shortcut: sin modelo validado no hay banda de IMC; cuando exista F3,
    // este es el único punto que debe cambiar.
    return const ScreeningAbstention(ScreeningAbstentionReason.noModel);
  }
}
