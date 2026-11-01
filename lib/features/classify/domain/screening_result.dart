import 'bmi_band.dart';

/// Confianza de la estimación según la calidad de la captura.
enum ScreeningConfidence { low, medium, high }

/// Resultado de un cribado: IMC estimado + índices antropométricos.
/// Solo on-device; nunca sale del dispositivo.
class ScreeningResult {
  const ScreeningResult({
    required this.bmi,
    required this.margin,
    required this.confidence,
    required this.waistToHeight,
    required this.bodyRoundness,
    required this.relativeFatMass,
  });

  final double bmi;

  /// Margen de error de la estimación (±IMC).
  final double margin;
  final ScreeningConfidence confidence;

  /// Cintura-altura (WHtR).
  final double waistToHeight;

  /// Redondez corporal (BRI).
  final double bodyRoundness;

  /// Masa grasa relativa (RFM), en porcentaje.
  final double relativeFatMass;

  BmiBand get band => classifyBmi(bmi);
  double get bmiMin => bmi - margin;
  double get bmiMax => bmi + margin;
}
