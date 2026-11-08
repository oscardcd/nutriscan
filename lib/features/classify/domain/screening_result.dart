import 'bmi_band.dart';

/// Confianza de la estimación según la calidad de la captura.
enum ScreeningConfidence { low, medium, high }

/// Resultado de un cribado: IMC + índices antropométricos.
/// Solo on-device; nunca sale del dispositivo.
///
/// Los campos opcionales son `null` cuando el dato no existe: el IMC se puede
/// calcular directo con peso y estatura (sin margen ni estimación), pero los
/// índices necesitan un modelo que aún no está integrado (F3). Nada se rellena
/// con valores inventados.
class ScreeningResult {
  const ScreeningResult({
    this.bmi,
    this.margin,
    this.confidence,
    this.waistToHeight,
    this.bodyRoundness,
    this.relativeFatMass,
  });

  /// IMC, solo cuando hay peso y estatura declarados. `null` si el resultado
  /// se limita a índices de forma (WHtR) medidos en la foto.
  final double? bmi;

  /// Margen de error (±IMC). `null` cuando el IMC es un cálculo directo.
  final double? margin;
  final ScreeningConfidence? confidence;

  /// Cintura-altura (WHtR).
  final double? waistToHeight;

  /// Redondez corporal (BRI).
  final double? bodyRoundness;

  /// Masa grasa relativa (RFM), en porcentaje.
  final double? relativeFatMass;

  bool get hasAnthropometrics =>
      waistToHeight != null || bodyRoundness != null || relativeFatMass != null;

  BmiBand? get band => bmi == null ? null : classifyBmi(bmi!);
  double? get bmiMin => bmi == null || margin == null ? null : bmi! - margin!;
  double? get bmiMax => bmi == null || margin == null ? null : bmi! + margin!;
}
