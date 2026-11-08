import '../../features/classify/domain/screening_result.dart';
import 'app_database.dart';
import 'measurement.dart';

/// Persistencia local de mediciones. Sin red, sin nube.
class MeasurementStore {
  MeasurementStore({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<int> save(ScreeningResult result, {DateTime? at}) async {
    final db = await _database.open();
    return db.insert('measurements', {
      'bmi': result.bmi,
      'margin': result.margin,
      'confidence': result.confidence!.name,
      'waist_to_height': result.waistToHeight,
      'body_roundness': result.bodyRoundness,
      'relative_fat_mass': result.relativeFatMass,
      'created_at': (at ?? DateTime.now()).millisecondsSinceEpoch,
    });
  }

  Future<List<Measurement>> recent({int limit = 50}) async {
    final db = await _database.open();
    final rows = await db.query(
      'measurements',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(Measurement.fromRow).toList();
  }

  Future<int> count() async {
    final db = await _database.open();
    final rows = await db.rawQuery('SELECT COUNT(*) AS c FROM measurements');
    return (rows.first['c'] as int?) ?? 0;
  }

  /// Borrado total: lo prometido en privacidad.
  Future<void> deleteAll() async {
    final db = await _database.open();
    await db.delete('measurements');
  }
}
