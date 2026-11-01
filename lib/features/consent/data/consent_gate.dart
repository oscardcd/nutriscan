import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'consent_store.dart';

/// Estado del consentimiento. Notifica al router para aplicar el guard.
class ConsentGate extends ChangeNotifier {
  ConsentGate({required bool initialGranted, ConsentStore? store})
    : _granted = initialGranted,
      _store = store ?? ConsentStore();

  final ConsentStore _store;
  bool _granted;

  bool get granted => _granted;

  Future<void> grant() async {
    await _store.grant();
    _granted = true;
    notifyListeners();
  }

  Future<void> revoke() async {
    await _store.clear();
    _granted = false;
    notifyListeners();
  }
}

/// Se sobreescribe en `main` con la instancia ya hidratada.
final consentGateProvider = Provider<ConsentGate>(
  (ref) => throw UnimplementedError('consentGateProvider debe sobreescribirse'),
);

final consentStoreProvider = Provider<ConsentStore>((ref) => ConsentStore());
