import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'features/consent/data/consent_gate.dart';
import 'features/consent/data/consent_store.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  // El consentimiento se hidrata antes del primer frame para que el guard
  // del router no parpadee la pantalla de bienvenida.
  final gate = ConsentGate(initialGranted: await ConsentStore().read() != null);

  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [consentGateProvider.overrideWithValue(gate)],
        child: NutriScanApp(router: buildRouter(gate)),
      ),
    ),
  );
}
