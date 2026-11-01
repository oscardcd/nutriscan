import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/data/local/app_database.dart';
import 'package:nutriscan/data/local/measurement_store.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late AppDatabase database;
  late MeasurementStore store;

  setUp(() async {
    database = AppDatabase.instance;
    await database.open(path: inMemoryDatabasePath);
    store = MeasurementStore(database: database);
  });

  tearDown(() => database.close());

  const result = ScreeningResult(
    bmi: 27.4,
    margin: 1.8,
    confidence: ScreeningConfidence.high,
    waistToHeight: 0.53,
    bodyRoundness: 3.8,
    relativeFatMass: 26.4,
  );

  test('guarda y recupera mediciones en orden descendente', () async {
    await store.save(result, at: DateTime(2026, 1, 1));
    await store.save(
      const ScreeningResult(
        bmi: 23.1,
        margin: 1.2,
        confidence: ScreeningConfidence.medium,
        waistToHeight: 0.46,
        bodyRoundness: 2.9,
        relativeFatMass: 21.0,
      ),
      at: DateTime(2026, 2, 1),
    );

    final rows = await store.recent();

    expect(rows, hasLength(2));
    expect(rows.first.result.bmi, 23.1);
    expect(rows.first.result.confidence, ScreeningConfidence.medium);
    expect(rows.first.createdAt, DateTime(2026, 2, 1));
    expect(rows.last.result.bmi, 27.4);
  });

  test('deleteAll deja la base vacía', () async {
    await store.save(result);
    expect(await store.count(), 1);

    await store.deleteAll();

    expect(await store.count(), 0);
    expect(await store.recent(), isEmpty);
  });
}
