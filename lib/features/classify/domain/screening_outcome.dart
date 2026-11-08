import 'screening_result.dart';

/// Lo que se puede entregar después de revisar una captura.
///
/// La abstención es un estado de primera clase: cuando no hay una estimación
/// válida no se rellena con valores inventados.
sealed class ScreeningOutcome {
  const ScreeningOutcome();
}

class ScreeningPrediction extends ScreeningOutcome {
  const ScreeningPrediction(this.result);

  final ScreeningResult result;
}

class ScreeningAbstention extends ScreeningOutcome {
  const ScreeningAbstention(this.reason);

  final ScreeningAbstentionReason reason;
}

enum ScreeningAbstentionReason {
  /// La pose no es lo bastante buena para medir nada.
  poseNotUsable,

  /// La pose se midió pero no cumple la guía de posición.
  alignmentFailed,

  /// No hay modelo de estimación validado en esta versión (F3 pendiente).
  noModel,

  /// Faltan peso y estatura: sin ellos no hay IMC que calcular.
  noBodyData,
}
