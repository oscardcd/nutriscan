import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/data/local/memory_measurement_store.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';

void main() {
  ScreeningResult result(double bmi) => ScreeningResult(
    bmi: bmi,
    margin: 1.5,
    confidence: ScreeningConfidence.medium,
    waistToHeight: 0.5,
    bodyRoundness: 3.0,
    relativeFatMass: 24.0,
  );

  test('fallback web: orden descendente, límite y borrado total', () async {
    final store = MemoryMeasurementStore();
    await store.save(result(27.4), at: DateTime(2026, 1, 1));
    await store.save(result(23.1), at: DateTime(2026, 2, 1));

    final rows = await store.recent();
    expect(rows.map((m) => m.result.bmi), [23.1, 27.4]);
    expect(rows.first.createdAt, DateTime(2026, 2, 1));
    expect(await store.recent(limit: 1), hasLength(1));

    await store.deleteAll();
    expect(await store.count(), 0);
  });
}
