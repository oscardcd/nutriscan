import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/capture/presentation/capture_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  Future<void> pumpCapture(WidgetTester tester, CaptureScreen screen) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: screen,
          ),
        ),
      ),
    );
  }

  testWidgets('captura muestra criterios y bloquea el obturador', (
    tester,
  ) async {
    await pumpCapture(tester, const CaptureScreen(visionAvailable: true));

    expect(find.text('Captura biométrica'), findsOneWidget);
    expect(find.text('CRITERIOS DE ESCANEO'), findsOneWidget);
    expect(find.text('Cuerpo completo, de frente'), findsOneWidget);
    // Guía estática, sin lecturas inventadas de sensor o distancia.
    expect(find.textContaining('Óptima'), findsNothing);
    expect(find.textContaining('2.1 m'), findsNothing);
    expect(find.textContaining('aprobados'), findsNothing);
    // La nota está en el scroll para dejar espacio en pantallas pequeñas.
    await tester.scrollUntilVisible(
      find.textContaining('modelo de visión esté integrado'),
      300,
    );
    expect(
      find.textContaining('modelo de visión esté integrado'),
      findsOneWidget,
    );
  });

  testWidgets('sin visión (web) muestra estado no disponible, sin obturador', (
    tester,
  ) async {
    await pumpCapture(tester, const CaptureScreen(visionAvailable: false));

    expect(
      find.text('Captura no disponible en este navegador'),
      findsOneWidget,
    );
    expect(find.text('CRITERIOS DE ESCANEO'), findsNothing);
    expect(find.byIcon(Icons.camera_alt), findsNothing);
  });
}
