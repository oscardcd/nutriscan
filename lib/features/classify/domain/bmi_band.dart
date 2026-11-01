/// Bandas OMS para adultos (≥18) definidas en docs/planning.md §5.
enum BmiBand {
  underweight,
  normal,
  overweight,
  obese;

  String get labelEs => switch (this) {
    BmiBand.underweight => 'Bajo peso',
    BmiBand.normal => 'Normal',
    BmiBand.overweight => 'Sobrepeso',
    BmiBand.obese => 'Obesidad',
  };

  /// Etiqueta de tamizaje, nunca de diagnóstico.
  bool get needsProfessionalReview => this == BmiBand.underweight;
}

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
