import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/core/theme/widgets/bmi_band_chip.dart';
import 'package:nutriscan/core/theme/widgets/bmi_range_gauge.dart';
import 'package:nutriscan/core/theme/widgets/medical_disclaimer.dart';
import 'package:nutriscan/core/ui/ui.dart';
import 'package:nutriscan/features/classify/domain/bmi_band.dart';
import 'package:nutriscan/i18n/strings.g.dart';

Widget _host(Widget child) => TranslationProvider(
  child: MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
  ),
);

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('AppCard, MetricTile y band chip renderizan', (tester) async {
    await tester.pumpWidget(
      _host(
        AppCard(
          child: MetricTile(
            label: 'IMC estimado',
            value: '27.4',
            unit: 'kg/m²',
            trailing: BmiBandChip(band: classifyBmi(27.4)),
          ),
        ),
      ),
    );
    expect(find.text('27.4'), findsOneWidget);
    expect(find.text('IMC ESTIMADO'), findsOneWidget);
  });

  testWidgets('BmiRangeGauge no desborda y dibuja marcador', (tester) async {
    await tester.pumpWidget(_host(const BmiRangeGauge(bmi: 27.4)));
    expect(tester.takeException(), isNull);
    expect(find.byType(BmiRangeGauge), findsOneWidget);
  });

  testWidgets('ConsentCheckbox alterna', (tester) async {
    var value = false;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => _host(
          ConsentCheckbox(
            prefix: 'Entiendo que es ',
            highlight: 'cribado',
            suffix: ' y no diagnóstico.',
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(value, isTrue);
  });

  testWidgets('Disclaimer y estado vacío renderizan', (tester) async {
    await tester.pumpWidget(
      _host(
        const Column(
          children: [
            MedicalDisclaimer(),
            EmptyState(
              icon: Icons.show_chart,
              title: 'Sin mediciones',
              message: 'Aún no hay datos',
            ),
          ],
        ),
      ),
    );
    expect(find.text('Sin mediciones'), findsOneWidget);
  });
}
