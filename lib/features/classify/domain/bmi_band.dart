/// Bandas OMS para adultos (≥18) definidas en docs/planning.md §5.
/// Etiquetas visibles viven en lib/i18n (band.*).
enum BmiBand { underweight, normal, overweight, obese }

BmiBand classifyBmi(double bmi) {
  if (bmi < 18.5) return BmiBand.underweight;
  if (bmi < 25) return BmiBand.normal;
  if (bmi < 30) return BmiBand.overweight;
  return BmiBand.obese;
}

/// IMC a partir de estatura en cm y peso en kg (referencia, no usado on-device).
double bmiFrom(double heightCm, double weightKg) {
  final m = heightCm / 100;
  return weightKg / (m * m);
}
