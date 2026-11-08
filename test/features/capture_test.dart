import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/core/theme/app_theme.dart';
import 'package:nutriscan/features/capture/data/capture_camera.dart';
import 'package:nutriscan/features/capture/presentation/capture_screen.dart';
import 'package:nutriscan/i18n/strings.g.dart';

class _FakeCaptureCamera implements CaptureCamera {
  int initializeCount = 0;
  int disposeCount = 0;
  int captureCount = 0;
  int openSettingsCount = 0;
  bool openSettingsResult = true;
  CaptureCameraException? initializationFailure;
  CaptureCameraException? captureFailure;
  bool previewIsMounted = false;
  bool disposedWhilePreviewMounted = false;

  @override
  Future<void> initialize() async {
    initializeCount++;
    final failure = initializationFailure;
    if (failure != null) {
      initializationFailure = null;
      throw failure;
    }
  }

  @override
  Widget buildPreview() => _FakeCameraPreview(
    onMount: () => previewIsMounted = true,
    onUnmount: () => previewIsMounted = false,
  );

  @override
  Future<Uint8List> takePicture() async {
    captureCount++;
    final failure = captureFailure;
    if (failure != null) {
      captureFailure = null;
      throw failure;
    }
    return base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p8sAAAAASUVORK5CYII=',
    );
  }

  @override
  Stream<CameraFrame> startStream() => const Stream.empty();

  @override
  Future<void> stopStream() async {}

  @override
  Future<bool> openSettings() async {
    openSettingsCount++;
    return openSettingsResult;
  }

  @override
  Future<void> dispose() async {
    if (previewIsMounted) disposedWhilePreviewMounted = true;
    disposeCount++;
  }
}

class _FakeCameraPreview extends StatefulWidget {
  const _FakeCameraPreview({required this.onMount, required this.onUnmount});

  final VoidCallback onMount;
  final VoidCallback onUnmount;

  @override
  State<_FakeCameraPreview> createState() => _FakeCameraPreviewState();
}

class _FakeCameraPreviewState extends State<_FakeCameraPreview> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  void dispose() {
    widget.onUnmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const ColoredBox(
    key: ValueKey('camera-preview'),
    color: Colors.black,
  );
}

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
    await tester.pump();
    await tester.pump();
  }

  Future<void> startCamera(WidgetTester tester) async {
    final startButton = find.text('Activar cámara');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
  }

  testWidgets('captura muestra criterios y preview de cámara', (tester) async {
    final camera = _FakeCaptureCamera();
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    expect(find.text('Captura biométrica'), findsOneWidget);
    expect(find.text('CRITERIOS DE ESCANEO'), findsOneWidget);
    expect(find.text('Buscando tu cuerpo…'), findsOneWidget);
    expect(camera.initializeCount, 0);
    await startCamera(tester);
    expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
    expect(camera.initializeCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('captura una foto local y permite repetirla', (tester) async {
    final camera = _FakeCaptureCamera();
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    await tester.tap(find.byTooltip('Capturar'));
    await tester.pumpAndSettle();

    expect(camera.captureCount, 1);
    expect(camera.disposeCount, 1);
    expect(camera.disposedWhilePreviewMounted, isFalse);
    expect(
      find.text(
        'Foto guardada temporalmente en memoria. El análisis visual aún no está disponible.',
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Tomar otra foto'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Tomar otra foto'));
    await tester.pumpAndSettle();

    expect(camera.initializeCount, 2);
    expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
  });

  testWidgets('un fallo de captura permite reintentar la cámara', (
    tester,
  ) async {
    final camera = _FakeCaptureCamera()
      ..captureFailure = const CaptureCameraException(
        CaptureCameraFailure.captureFailed,
      );
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    await tester.tap(find.byTooltip('Capturar'));
    await tester.pumpAndSettle();

    expect(
      find.text('No se pudo iniciar o usar la cámara. Inténtalo de nuevo.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.byKey(const ValueKey('camera-preview')), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(camera.initializeCount, 2);
    expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('muestra permiso denegado y permite reintentarlo', (
    tester,
  ) async {
    final camera = _FakeCaptureCamera()
      ..initializationFailure = const CaptureCameraException(
        CaptureCameraFailure.permissionDenied,
      );
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    expect(
      find.text('Se necesita permiso para usar la cámara.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(camera.initializeCount, 2);
    expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
  });

  testWidgets('permiso permanente ofrece abrir los ajustes', (tester) async {
    final camera = _FakeCaptureCamera()
      ..initializationFailure = const CaptureCameraException(
        CaptureCameraFailure.permissionPermanentlyDenied,
      );
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    expect(
      find.text(
        'El permiso está desactivado. Actívalo en los ajustes de la app.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Abrir ajustes'));
    await tester.pumpAndSettle();

    expect(camera.openSettingsCount, 1);
    expect(camera.initializeCount, 2);
    expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
  });

  testWidgets('informa si no se pudieron abrir los ajustes', (tester) async {
    final camera = _FakeCaptureCamera()
      ..initializationFailure = const CaptureCameraException(
        CaptureCameraFailure.permissionPermanentlyDenied,
      )
      ..openSettingsResult = false;
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    await tester.tap(find.text('Abrir ajustes'));
    await tester.pumpAndSettle();

    expect(
      find.text('No se pudo iniciar o usar la cámara. Inténtalo de nuevo.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
    expect(camera.initializeCount, 1);
  });

  testWidgets('libera y reinicia la cámara al pausar y reanudar', (
    tester,
  ) async {
    final camera = _FakeCaptureCamera();
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: true, camera: camera),
    );

    await startCamera(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(camera.disposeCount, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(camera.initializeCount, 2);
    expect(camera.disposedWhilePreviewMounted, isFalse);
  });

  testWidgets('web mantiene captura deshabilitada sin inicializar cámara', (
    tester,
  ) async {
    final camera = _FakeCaptureCamera();
    await pumpCapture(
      tester,
      CaptureScreen(visionAvailable: false, camera: camera),
    );

    expect(
      find.text('Captura no disponible en este navegador'),
      findsOneWidget,
    );
    expect(find.text('Activar cámara'), findsNothing);
    expect(find.byTooltip('Capturar'), findsNothing);
    expect(camera.initializeCount, 0);
  });
}
