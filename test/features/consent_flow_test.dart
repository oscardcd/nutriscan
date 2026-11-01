import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/router/app_router.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/consent/data/consent_gate.dart';
import 'package:nutriscan/features/consent/data/consent_store.dart';
import 'package:nutriscan/i18n/strings.g.dart';

/// Guarda el consentimiento en memoria: el keystore no existe en tests.
class _MemoryConsentStore extends ConsentStore {
  bool value = false;

  @override
  Future<DateTime?> read() async => value ? DateTime(2026) : null;

  @override
  Future<void> grant({DateTime? at}) async => value = true;

  @override
  Future<void> clear() async => value = false;
}

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  Future<ConsentGate> pumpApp(
    WidgetTester tester, {
    required bool granted,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final store = _MemoryConsentStore()..value = granted;
    final gate = ConsentGate(initialGranted: granted, store: store);

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [consentGateProvider.overrideWithValue(gate)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            routerConfig: buildRouter(gate),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return gate;
  }

  testWidgets('sin consentimiento el flujo arranca en /welcome', (
    tester,
  ) async {
    await pumpApp(tester, granted: false);

    expect(find.text('Comenzar evaluación'), findsOneWidget);
    expect(find.text('Captura biométrica'), findsNothing);
  });

  testWidgets('con consentimiento guardado se entra directo a /capture', (
    tester,
  ) async {
    await pumpApp(tester, granted: true);

    expect(find.text('Captura biométrica'), findsOneWidget);
    expect(find.text('Comenzar evaluación'), findsNothing);
  });

  testWidgets('otorgar consentimiento navega a /capture y lo persiste', (
    tester,
  ) async {
    final gate = await pumpApp(tester, granted: false);

    await tester.tap(find.byType(Checkbox).at(0));
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    await tester.tap(find.text('Comenzar evaluación'));
    await tester.pumpAndSettle();

    expect(gate.granted, isTrue);
    expect(find.text('Captura biométrica'), findsOneWidget);
  });
}
