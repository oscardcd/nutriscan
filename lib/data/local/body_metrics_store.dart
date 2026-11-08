import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'body_metrics.dart';

/// Persistencia local de peso y estatura.
abstract interface class BodyMetricsStore {
  Future<BodyMetrics?> read();
  Future<void> write(BodyMetrics metrics);
}

/// Guardado en el keystore/keychain, igual que el consentimiento.
class SecureBodyMetricsStore implements BodyMetricsStore {
  SecureBodyMetricsStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _heightKey = 'body_height_cm';
  static const _weightKey = 'body_weight_kg';

  final FlutterSecureStorage _storage;

  @override
  Future<BodyMetrics?> read() async {
    final height = double.tryParse(
      await _storage.read(key: _heightKey) ?? '',
    );
    final weight = double.tryParse(
      await _storage.read(key: _weightKey) ?? '',
    );
    if (height == null || weight == null) return null;
    return BodyMetrics(heightCm: height, weightKg: weight);
  }

  @override
  Future<void> write(BodyMetrics metrics) async {
    await _storage.write(key: _heightKey, value: '${metrics.heightCm}');
    await _storage.write(key: _weightKey, value: '${metrics.weightKg}');
  }
}

/// Fallback para web y pruebas.
class MemoryBodyMetricsStore implements BodyMetricsStore {
  MemoryBodyMetricsStore([this._value]);

  BodyMetrics? _value;

  @override
  Future<BodyMetrics?> read() async => _value;

  @override
  Future<void> write(BodyMetrics metrics) async => _value = metrics;
}
