import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';
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

  testWidgets('resultado muestra IMC, índices y disclaimer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: const ResultScreen(result: result),
          ),
        ),
      ),
    );

    expect(find.text('27.4'), findsOneWidget);
    expect(find.text('Sobrepeso'), findsNWidgets(2));
    expect(find.text('Cintura-altura (WHtR)'), findsOneWidget);
    expect(find.text('Confianza alta'), findsOneWidget);
    expect(find.textContaining('No es un diagnóstico'), findsOneWidget);
  });
}
