import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/capture/presentation/capture_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('captura muestra criterios y bloquea el obturador', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('es'),
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const CaptureScreen(),
        ),
      ),
    );

    expect(find.text('Captura biométrica'), findsOneWidget);
    expect(find.text('CRITERIOS DE ESCANEO'), findsOneWidget);
    expect(find.text('3 / 4 aprobados'), findsOneWidget);
    expect(
      find.textContaining('modelo de visión esté integrado'),
      findsOneWidget,
    );
  });
}
