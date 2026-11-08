import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';
import 'package:nutriscan/features/classify/domain/screening_outcome.dart';
import 'package:nutriscan/features/classify/domain/screening_result.dart';
import 'package:nutriscan/features/result/presentation/result_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

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

  test('banda y rango del resultado', () {
    expect(result.band, BmiBand.overweight);
    expect(result.bmiMin, closeTo(25.6, 0.001));
    expect(result.bmiMax, closeTo(29.2, 0.001));
  });

  Future<void> pumpResult(WidgetTester tester, AppLocale locale) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    LocaleSettings.setLocale(locale);
    addTearDown(() => LocaleSettings.setLocale(AppLocale.es));

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: locale.flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: const ResultScreen(outcome: ScreeningPrediction(result)),
          ),
        ),
      ),
    );
  }

  testWidgets('resultado muestra IMC, índices y disclaimer', (tester) async {
    await pumpResult(tester, AppLocale.es);

    expect(find.text('27,4'), findsOneWidget);
    expect(find.text('±1,8 · rango de estimación 25,6 – 29,2'), findsOneWidget);
    expect(find.text('0,53'), findsOneWidget);
    expect(find.text('Sobrepeso'), findsNWidgets(2));
    expect(find.text('CINTURA-ALTURA (WHTR)'), findsOneWidget);
    expect(find.text('Confianza alta'), findsOneWidget);
    expect(find.text('RESULTADO EXPERIMENTAL'), findsOneWidget);
    expect(
      find.textContaining('no están validados para uso médico'),
      findsOneWidget,
    );
  });

  testWidgets('en inglés los decimales usan punto', (tester) async {
    await pumpResult(tester, AppLocale.en);

    expect(find.text('27.4'), findsOneWidget);
    expect(find.text('±1.8 · estimate range 25.6 – 29.2'), findsOneWidget);
    expect(find.text('EXPERIMENTAL RESULT'), findsOneWidget);
    expect(
      find.textContaining('not validated for medical use'),
      findsOneWidget,
    );
  });
}
