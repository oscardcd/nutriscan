import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/features/vision/data/pose_analysis_service.dart';
import 'package:nutriscan/features/vision/domain/pose_alignment.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';
import 'package:nutriscan/features/vision/presentation/pose_debug_panel.dart';
import 'package:nutriscan/i18n/strings.g.dart';

class _FakeAnalysisService extends PoseAnalysisService {
  _FakeAnalysisService(this.result);

  final PoseAnalysis result;
  int analyzeCount = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<PoseAnalysis> analyze(Uint8List imageBytes) async {
    analyzeCount++;
    return result;
  }

  @override
  Future<void> dispose() async {}
}

PoseAnalysis _analysis(AlignmentHint alignment) => PoseAnalysis(
  quality: PoseQuality.usableForTechnicalChecks,
  imageWidth: 480,
  imageHeight: 640,
  processingTime: const Duration(milliseconds: 30),
  alignment: alignment,
);

Future<void> _pump(WidgetTester tester, PoseAnalysisService service) =>
    tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          locale: const Locale('es'),
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: PoseDebugPanel(
              image: Uint8List.fromList([1, 2, 3]),
              service: service,
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('analiza la foto sola y avisa sin bloquear', (tester) async {
    final service = _FakeAnalysisService(
      _analysis(AlignmentHint.notCentered),
    );
    await _pump(tester, service);
    await tester.pumpAndSettle();

    expect(service.analyzeCount, 1);
    expect(find.text('Céntrate en el encuadre'), findsOneWidget);
    expect(
      find.text('La foto se guarda igual; puedes repetirla si quieres.'),
      findsOneWidget,
    );
  });

  testWidgets('con la pose correcta no muestra aviso', (tester) async {
    await _pump(tester, _FakeAnalysisService(_analysis(AlignmentHint.ok)));
    await tester.pumpAndSettle();

    expect(find.text('Posición correcta'), findsOneWidget);
    expect(
      find.text('La foto se guarda igual; puedes repetirla si quieres.'),
      findsNothing,
    );
  });
}
