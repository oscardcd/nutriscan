import '../../features/classify/domain/screening_result.dart';

/// Una medición guardada en el dispositivo.
class Measurement {
  const Measurement({
    required this.id,
    required this.result,
    required this.createdAt,
  });

  final int id;
  final ScreeningResult result;
  final DateTime createdAt;

  factory Measurement.fromRow(Map<String, Object?> row) => Measurement(
    id: row['id']! as int,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
    result: ScreeningResult(
      bmi: row['bmi']! as double,
      margin: row['margin']! as double,
      confidence: ScreeningConfidence.values.byName(
        row['confidence']! as String,
      ),
      waistToHeight: row['waist_to_height']! as double,
      bodyRoundness: row['body_roundness']! as double,
      relativeFatMass: row['relative_fat_mass']! as double,
    ),
  );
}
