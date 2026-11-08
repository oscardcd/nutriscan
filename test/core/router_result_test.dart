import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/core/router/app_router.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';
import 'package:nutriscan/features/consent/data/consent_gate.dart';
import 'package:nutriscan/features/consent/data/consent_store.dart';
import 'package:nutriscan/i18n/strings.g.dart';

/// El consentimiento no se toca en estos tests: solo importa el guard de /result.
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

  GoRouter? router;

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final gate = ConsentGate(initialGranted: true, store: _NoopConsentStore());
    final appRouter = buildRouter(gate);
    router = appRouter;
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [consentGateProvider.overrideWithValue(gate)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            routerConfig: appRouter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('/result sin desenlace redirige a captura', (tester) async {
    await pumpApp(tester);

    router!.go('/result');
    await tester.pumpAndSettle();

    expect(find.text('Captura biométrica'), findsOneWidget);
    expect(find.text('RESULTADO EXPERIMENTAL'), findsNothing);
  });

  testWidgets('/result con extra muestra el resultado', (tester) async {
    await pumpApp(tester);

    router!.go(
      '/result',
      extra: const ScreeningPrediction(
        ScreeningResult(
          bmi: 27.4,
          margin: 1.8,
          confidence: ScreeningConfidence.high,
          waistToHeight: 0.53,
          bodyRoundness: 3.8,
          relativeFatMass: 26.4,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('27,4'), findsOneWidget);
    expect(find.text('RESULTADO EXPERIMENTAL'), findsOneWidget);
  });
}
