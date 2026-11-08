import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';
import 'package:nutriscan/features/consent/data/consent_gate.dart';
import 'package:nutriscan/features/consent/data/consent_store.dart';
import 'package:nutriscan/features/consent/presentation/consent_screen.dart';
import 'package:nutriscan/features/result/presentation/result_screen.dart';
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

  const result = ScreeningResult(
    bmi: 27.4,
    margin: 1.8,
    confidence: ScreeningConfidence.high,
    waistToHeight: 0.53,
    bodyRoundness: 3.8,
    relativeFatMass: 26.4,
  );

  Future<void> pump(WidgetTester tester, Widget screen) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final gate = ConsentGate(initialGranted: true, store: _NoopConsentStore());
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [consentGateProvider.overrideWithValue(gate)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [GoRoute(path: '/', builder: (_, _) => screen)],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('la casilla de consentimiento se lee como un solo control', (
    tester,
  ) async {
    await pump(tester, const ConsentScreen());

    final data = tester
        .getSemantics(find.byType(Checkbox).first)
        .getSemanticsData();

    expect(data.label, contains('prototipo educativo experimental'));
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('el avatar sin acción no se muestra en consentimiento', (
    tester,
  ) async {
    await pump(tester, const ConsentScreen());

    expect(find.byIcon(Icons.person_outline), findsNothing);
  });

  testWidgets('el resultado muestra avatar con etiqueta y gauge accesible', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, const ResultScreen(outcome: ScreeningPrediction(result)));

    expect(find.byTooltip('Perfil'), findsOneWidget);
    expect(find.bySemanticsLabel('Escala OMS'), findsOneWidget);
    semantics.dispose();
  });
}
