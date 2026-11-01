import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';

void main() {
  test('bandas OMS adulto en los límites', () {
    expect(classifyBmi(18.49), BmiBand.underweight);
    expect(classifyBmi(18.5), BmiBand.normal);
    expect(classifyBmi(24.9), BmiBand.normal);
    expect(classifyBmi(25.0), BmiBand.overweight);
    expect(classifyBmi(29.9), BmiBand.overweight);
    expect(classifyBmi(30.0), BmiBand.obese);
  });

  test('bmiFrom usa estatura en cm', () {
    expect(bmiFrom(170, 70).toStringAsFixed(1), '24.2');
  });
}
