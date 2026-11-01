import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/app.dart';
import 'package:nutriscan/core/router/app_router.dart';
import 'package:nutriscan/features/consent/data/consent_gate.dart';
import 'package:nutriscan/features/consent/data/consent_store.dart';
import 'package:nutriscan/i18n/strings.g.dart';

class _NoopConsentStore extends ConsentStore {
  @override
  Future<DateTime?> read() async => DateTime(2026);

  @override
  Future<void> grant({DateTime? at}) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final gate = ConsentGate(initialGranted: true, store: _NoopConsentStore());
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [consentGateProvider.overrideWithValue(gate)],
          child: NutriScanApp(router: buildRouter(gate)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('el menú cambia el tema de la app', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(find.text('Oscuro'), findsOneWidget);

    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('el menú cambia el idioma de la app', (tester) async {
    await pumpApp(tester);
    expect(find.text('Captura biométrica'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Biometric capture'), findsOneWidget);
  });
}
