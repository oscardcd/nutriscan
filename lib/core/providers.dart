import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/body_metrics_store.dart';
import '../data/local/measurement_store.dart';
import '../data/local/memory_measurement_store.dart';

/// Storage local disponible para la UI (borrado total desde Perfil).
/// En web no hay SQLite: se usa el fallback en memoria.
final measurementStoreProvider = Provider<MeasurementStore>(
  (ref) => kIsWeb ? MemoryMeasurementStore() : MeasurementStore(),
);

/// Peso y estatura: keychain en móvil, memoria en web.
final bodyMetricsStoreProvider = Provider<BodyMetricsStore>(
  (ref) => kIsWeb ? MemoryBodyMetricsStore() : SecureBodyMetricsStore(),
);
