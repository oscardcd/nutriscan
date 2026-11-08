import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/router/app_router.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/capture/presentation/capture_screen.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';
import 'package:nutriscan/features/consent/data/consent_gate.dart';
import 'package:nutriscan/features/consent/data/consent_store.dart';
import 'package:nutriscan/features/consent/presentation/consent_screen.dart';
import 'package:nutriscan/features/history/presentation/history_screen.dart';
import 'package:nutriscan/features/profile/presentation/profile_screen.dart';
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

/// Recorre el scroll vertical principal: ListView solo pinta lo visible.
Future<void> _scrollToEnd(WidgetTester tester) async {
  final scrollable = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  if (scrollable.evaluate().isEmpty) return;
  final position = tester.state<ScrollableState>(scrollable.first).position;
  while (position.pixels < position.maxScrollExtent) {
    await tester.drag(scrollable.first, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
}

/// Pantallas que deben caber en 320 dp con texto al 200 %.
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

  final screens = <String, Widget>{
    'consentimiento': const ConsentScreen(),
    'captura': const CaptureScreen(),
    'resultado': const ResultScreen(outcome: ScreeningPrediction(result)),
  };

  Widget textX2(BuildContext context, Widget? child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(2)),
    child: child!,
  );

  Future<ConsentGate> setUp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    return ConsentGate(initialGranted: true, store: _NoopConsentStore());
  }

  for (final entry in screens.entries) {
    testWidgets('${entry.key} cabe en 320 dp con texto x2', (tester) async {
      final gate = await setUp(tester);
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [consentGateProvider.overrideWithValue(gate)],
            child: MaterialApp(
              theme: AppTheme.light,
              locale: const Locale('es'),
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              builder: textX2,
              home: entry.value,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _scrollToEnd(tester);

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('la barra inferior navega entre tabs en 320 dp con texto x2', (
    tester,
  ) async {
    final gate = await setUp(tester);
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [consentGateProvider.overrideWithValue(gate)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            builder: textX2,
            routerConfig: buildRouter(gate),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // (destino en la barra, pantalla visible). Se busca por tipo: "Perfil" es
    // a la vez label de la barra y título de la pantalla.
    final tabs = [
      (t.nav.history, HistoryScreen),
      (t.nav.profile, ProfileScreen),
      (t.nav.measure, CaptureScreen),
    ];
    expect(find.byType(CaptureScreen), findsOneWidget);
    await _scrollToEnd(tester);
    for (final (tab, screen) in tabs) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(tab),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: tab);
      await _scrollToEnd(tester);
      expect(tester.takeException(), isNull, reason: tab);
    }
  });
}
