import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/consent/presentation/consent_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  Future<void> pumpConsent(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: const ConsentScreen(),
          ),
        ),
      ),
    );
  }

  testWidgets('CTA bloqueado hasta aceptar ambos consentimientos', (
    tester,
  ) async {
    await pumpConsent(tester);

    FilledButton cta() =>
        tester.widget<FilledButton>(find.byType(FilledButton));
    expect(cta().onPressed, isNull);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(cta().onPressed, isNull);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    expect(cta().onPressed, isNotNull);
  });

  testWidgets('muestra los tres avisos y el disclaimer', (tester) async {
    await pumpConsent(tester);

    expect(find.text('100% en tu dispositivo'), findsOneWidget);
    expect(find.text('Privacidad fotográfica estricta'), findsOneWidget);
    expect(find.text('Herramienta de cribado preventivo'), findsOneWidget);
    expect(find.textContaining('No es un diagnóstico'), findsOneWidget);
  });
}
