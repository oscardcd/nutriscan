import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Consentimiento guardado en el keystore/keychain del dispositivo.
class ConsentStore {
  ConsentStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'consent_granted_at';

  final FlutterSecureStorage _storage;

  /// Fecha en que se otorgó el consentimiento, o `null` si no existe.
  Future<DateTime?> read() async {
    final raw = await _storage.read(key: _key);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> grant({DateTime? at}) => _storage.write(
    key: _key,
    value: (at ?? DateTime.now()).toIso8601String(),
  );

  Future<void> clear() => _storage.delete(key: _key);
}
