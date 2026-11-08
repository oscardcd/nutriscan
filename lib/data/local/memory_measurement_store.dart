import '../../features/classify/domain/screening_result.dart';
import 'measurement.dart';
import 'measurement_store.dart';

/// Fallback para web, donde `sqflite` no tiene backend.
///
/// shortcut: los datos viven solo en memoria y se pierden al recargar la
/// pestaña; migrar a IndexedDB (p. ej. `sqflite_common_ffi_web`) cuando el
/// historial deba persistir en navegador.
class MemoryMeasurementStore implements MeasurementStore {
  final _rows = <Map<String, Object?>>[];

  @override
  Future<int> save(ScreeningResult result, {DateTime? at}) async {
    final id = _rows.length + 1;
    _rows.add({
      'id': id,
      'bmi': result.bmi,
      'margin': result.margin,
      'confidence': result.confidence!.name,
      'waist_to_height': result.waistToHeight,
      'body_roundness': result.bodyRoundness,
      'relative_fat_mass': result.relativeFatMass,
      'created_at': (at ?? DateTime.now()).millisecondsSinceEpoch,
    });
    return id;
  }

  @override
  Future<List<Measurement>> recent({int limit = 50}) async {
    final sorted = [..._rows]
      ..sort(
        (a, b) => (b['created_at']! as int).compareTo(a['created_at']! as int),
      );
    return sorted.take(limit).map(Measurement.fromRow).toList();
  }

  @override
  Future<int> count() async => _rows.length;

  @override
  Future<void> deleteAll() async => _rows.clear();
}
