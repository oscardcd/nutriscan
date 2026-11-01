import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/profile/presentation/profile_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('perfil: datos sin implementar deshabilitados, borrar confirma', (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProfileScreen(),
          ),
        ),
      ),
    );

    for (final label in ['Estatura', 'Sexo', 'Edad']) {
      final tile = tester.widget<ListTile>(
        find.ancestor(of: find.text(label), matching: find.byType(ListTile)),
      );
      expect(tile.enabled, isFalse, reason: label);
    }
    expect(find.text('Próximamente'), findsNWidgets(3));

    // Borrar pide confirmación; cancelar no toca el storage.
    await tester.tap(find.text('Borrar todos los datos'));
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar todos los datos?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
