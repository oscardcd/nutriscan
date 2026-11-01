import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/measurement_store.dart';

/// Storage local disponible para la UI (borrado total desde Perfil).
final measurementStoreProvider = Provider<MeasurementStore>(
  (ref) => MeasurementStore(),
);
