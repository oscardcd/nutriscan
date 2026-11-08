import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/ui.dart';
import '../../../data/local/body_metrics.dart';
import '../../../data/local/body_metrics_store.dart';
import '../../../i18n/strings.g.dart';
import '../../classify/application/screening_service.dart';
import '../../classify/domain/screening_outcome.dart';
import '../../vision/data/pose_analysis_service.dart';
import '../../vision/data/pose_realtime_detector.dart';
import '../../vision/domain/pose_alignment.dart';
import '../../vision/domain/pose_analysis.dart';
import '../../vision/presentation/alignment_text.dart';
import '../../vision/presentation/photo_alignment_watcher_stub.dart'
    if (dart.library.io) '../../vision/presentation/photo_alignment_watcher.dart';
import '../../vision/presentation/pose_debug_panel_stub.dart'
    if (dart.library.io) '../../vision/presentation/pose_debug_panel.dart';
import '../../vision/presentation/pose_guide_painter.dart';
import '../data/capture_camera.dart';
import 'widgets/body_metrics_dialog.dart';
import 'widgets/camera_placeholder.dart';
import 'widgets/corners_painter.dart';
import 'widgets/criteria_card.dart';
import 'widgets/overlay_controls.dart';
import 'widgets/overlay_header.dart';

const _captureTimeout = Duration(seconds: 30);

/// Captura guiada. La guía (encuadre, inclinación, distancia) es estática por
/// ahora: shortcut: sin pipeline de visión conectado, los valores se alimentan
/// cuando `core/vision` entregue pose + segmentación.
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({
    super.key,
    this.visionAvailable = !kIsWeb,
    this.camera,
    this.analysisService,
    this.onUsePhoto,
    this.bodyMetricsStore,
  });

  /// Cámara y modelos de visión (ML Kit, TFLite) solo existen en móvil.
  final bool visionAvailable;
  final CaptureCamera? camera;

  /// Inyectable para pruebas; por defecto la pantalla crea la suya.
  final PoseAnalysisService? analysisService;

  /// Qué hacer con la foto aceptada. Por defecto abre `/result`; las pruebas
  /// lo usan para no depender del router.
  final void Function(ScreeningOutcome outcome)? onUsePhoto;

  /// Peso y estatura: keychain en móvil, inyectable en pruebas.
  final BodyMetricsStore? bodyMetricsStore;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver {
  late final CaptureCamera _camera = widget.camera ?? DeviceCaptureCamera();
  bool _isInitializing = false;
  bool _isCameraReady = false;
  bool _isCapturing = false;
  bool _isAppResumed = true;
  bool _hasStartedCamera = false;
  int _operationId = 0;
  CaptureCameraFailure? _failure;
  Uint8List? _capturedImage;

  static const PoseAlignmentEvaluator _alignmentEvaluator =
      PoseAlignmentEvaluator();

  /// Frames alineados seguidos antes de habilitar el disparador.
  static const int _gateFrames = 3;

  /// Tras este tiempo el disparador se abre aunque la pose no valide.
  static const Duration _captureGateTimeout = Duration(seconds: 10);

  final ValueNotifier<DetectedPose?> _livePose = ValueNotifier(null);
  final ValueNotifier<AlignmentHint?> _liveHint = ValueNotifier(null);
  AlignmentHint? _lastAnnouncedHint;
  Uint8List? _analyzedImage;
  final AlignmentStabilizer _alignmentStabilizer = AlignmentStabilizer();
  int _alignedFrames = 0;
  bool _gateOpen = false;
  bool _escapeReady = false;
  Timer? _escapeTimer;
  StreamSubscription<CameraFrame>? _poseFrames;
  PoseRealtimeDetector? _poseDetector;

  /// Una sola instancia para toda la pantalla: el detector nativo es único y
  /// cerrarlo desde el panel o el watcher deja a la cámara sin detector.
  PoseAnalysisService? _analysisService;
  PoseAnalysisService get _analysisServiceOrCreate =>
      _analysisService ??= widget.analysisService ?? PoseAnalysisService();
  late final BodyMetricsStore _metricsStore =
      widget.bodyMetricsStore ??
      (kIsWeb ? MemoryBodyMetricsStore() : SecureBodyMetricsStore());
  Timer? _poseIdleTimer;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    _isAppResumed = resumed;

    if (!resumed) {
      _operationId++;
      _isInitializing = false;
      _isCapturing = false;
      _isCameraReady = false;
      if (mounted && widget.visionAvailable && _capturedImage == null) {
        setState(() {});
      }
      unawaited(_stopPoseStream());
      unawaited(
        _disposeCameraAfterPreviewRemoved(_operationId, onlyWhenPaused: true),
      );
    } else if (widget.visionAvailable &&
        _hasStartedCamera &&
        _capturedImage == null) {
      unawaited(_initializeCamera());
    }
  }

  Future<void> _initializeCamera() async {
    if (!mounted || !_isAppResumed || _isInitializing || _isCapturing) return;
    final operationId = ++_operationId;

    setState(() {
      _hasStartedCamera = true;
      _isInitializing = true;
      _isCameraReady = false;
      _failure = null;
    });

    try {
      await _camera.initialize();
      if (operationId != _operationId) return;
      if (!mounted || !_isAppResumed) {
        await _disposeCamera();
        return;
      }
      setState(() => _isCameraReady = true);
      _startEscapeTimer();
      // No se espera: el modelo puede tardar y el preview ya es usable.
      unawaited(_startPoseStream());
    } on CaptureCameraException catch (error) {
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = error.failure);
        _announceFailure(error.failure);
      }
    } on CameraException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = CaptureCameraFailure.unavailable);
        _announceFailure(CaptureCameraFailure.unavailable);
      }
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = CaptureCameraFailure.unavailable);
        _announceFailure(CaptureCameraFailure.unavailable);
      }
    } finally {
      if (operationId == _operationId && mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraReady || _isCapturing) return;
    final operationId = ++_operationId;
    setState(() {
      _isCapturing = true;
      _failure = null;
    });

    try {
      await _stopPoseStream();
      final image = await _camera.takePicture().timeout(_captureTimeout);
      if (operationId != _operationId || !_isAppResumed) {
        image.fillRange(0, image.length, 0);
        return;
      }
      if (!mounted) return;
      setState(() {
        _capturedImage = image;
        _isCameraReady = false;
      });
      _showSnack(
        Translations.of(context).capture.cameraCaptured,
        icon: Icons.check_circle_outline,
      );
      await _disposeCameraAfterPreviewRemoved(operationId);
    } on CaptureCameraException catch (error) {
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = error.failure;
        });
        _announceFailure(error.failure);
      }
    } on TimeoutException {
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
        _announceFailure(CaptureCameraFailure.captureFailed);
      }
    } on CameraException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
        _announceFailure(CaptureCameraFailure.captureFailed);
      }
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
        _announceFailure(CaptureCameraFailure.captureFailed);
      }
    } finally {
      if (operationId == _operationId && mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _retakeImage() async {
    final image = _capturedImage;
    if (image != null) image.fillRange(0, image.length, 0);
    setState(() => _capturedImage = null);
    await _initializeCamera();
  }

  Future<void> _openCameraSettings() async {
    try {
      final opened = await _camera.openSettings();
      if (opened && _isAppResumed) await _initializeCamera();
      if (!opened && mounted) {
        setState(() => _failure = CaptureCameraFailure.unavailable);
        _announceFailure(CaptureCameraFailure.unavailable);
      }
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (mounted) setState(() => _failure = CaptureCameraFailure.unavailable);
    } on MissingPluginException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (mounted) setState(() => _failure = CaptureCameraFailure.unavailable);
    }
  }

  Future<void> _disposeCamera() async {
    await _stopPoseStream();
    try {
      await _camera.dispose();
    } on CameraException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    }
  }

  Future<void> _disposeCameraAfterPreviewRemoved(
    int operationId, {
    bool onlyWhenPaused = false,
  }) async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || operationId != _operationId) return;
    if (onlyWhenPaused && _isAppResumed) return;
    await _disposeCamera();
  }

  Future<void> _startPoseStream() async {
    if (!widget.visionAvailable ||
        _poseFrames != null ||
        _capturedImage != null) {
      return;
    }
    final detector = _poseDetector ??= PoseRealtimeDetector();
    try {
      await detector.initialize();
      if (!mounted || !_isCameraReady || !_isAppResumed) return;
      _poseFrames = _camera.startStream().listen(
        _onPoseFrame,
        onError: _reportCameraError,
      );
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    } on StateError catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    }
  }

  /// Sin esto, una pose que nunca se valida deja el disparador bloqueado.
  void _startEscapeTimer() {
    _escapeTimer?.cancel();
    _escapeReady = false;
    _escapeTimer = Timer(_captureGateTimeout, () {
      if (!mounted || _disposed) return;
      setState(() => _escapeReady = true);
    });
  }

  bool get _canCapture =>
      _isCameraReady &&
      !_isCapturing &&
      (_gateOpen || _escapeReady || !widget.visionAvailable);

  Future<void> _stopPoseStream() async {
    _poseIdleTimer?.cancel();
    final frames = _poseFrames;
    _poseFrames = null;
    await frames?.cancel();
    if (!_disposed) {
      _livePose.value = null;
      _liveHint.value = null;
    }
    _lastAnnouncedHint = null;
    _alignmentStabilizer.reset();
    _resetGate();
    try {
      await _camera.stopStream();
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
    }
  }

  Future<void> _onPoseFrame(CameraFrame frame) async {
    final detector = _poseDetector;
    if (detector == null) return;
    final pose = await detector.process(frame);
    if (!mounted || _disposed || _poseFrames == null) return;
    if (pose == null) {
      _livePose.value = null;
      _liveHint.value = null;
      _alignmentStabilizer.reset();
      return;
    }
    _livePose.value = pose;
    final hint = _alignmentStabilizer.update(
      _alignmentEvaluator.evaluate(pose),
    );
    _liveHint.value = hint;
    _announceHint(hint);
    _alignedFrames = hint == AlignmentHint.ok ? _alignedFrames + 1 : 0;
    final open = _alignedFrames >= _gateFrames;
    if (open != _gateOpen) setState(() => _gateOpen = open);
    _poseIdleTimer?.cancel();
    _poseIdleTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted || _disposed) return;
      _livePose.value = null;
      _liveHint.value = null;
      _alignmentStabilizer.reset();
      _resetGate();
    });
  }

  void _resetGate() {
    _alignedFrames = 0;
    if (!_gateOpen) return;
    _gateOpen = false;
    if (mounted && !_disposed) setState(() {});
  }

  void _reportCameraError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'NutriScan camera capture',
        context: ErrorDescription('while initializing or capturing an image'),
      ),
    );
  }

  String _failureMessage(Translations t, CaptureCameraFailure failure) =>
      switch (failure) {
        CaptureCameraFailure.permissionDenied => t.capture.cameraPermission,
        CaptureCameraFailure.permissionPermanentlyDenied =>
          t.capture.cameraPermissionSettings,
        CaptureCameraFailure.permissionRestricted =>
          t.capture.cameraPermissionRestricted,
        CaptureCameraFailure.noCamera => t.capture.cameraUnavailable,
        CaptureCameraFailure.unavailable ||
        CaptureCameraFailure.captureFailed ||
        CaptureCameraFailure.interrupted => t.capture.cameraError,
      };

  @override
  void dispose() {
    _operationId++;
    _disposed = true;
    _poseIdleTimer?.cancel();
    _escapeTimer?.cancel();
    unawaited(_poseFrames?.cancel());
    _poseFrames = null;
    _poseDetector?.dispose();
    // Solo se cierra lo que creó la pantalla.
    if (widget.analysisService == null) {
      unawaited(_analysisService?.dispose());
    }
    _livePose.dispose();
    _liveHint.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _capturedImage?.fillRange(0, _capturedImage!.length, 0);
    unawaited(_disposeCamera());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    if (!widget.visionAvailable) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              OverlayHeader(
                title: t.capture.title,
                subtitle: t.capture.onDevice,
                foreground: theme.colorScheme.onSurface,
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.no_photography_outlined,
                  title: t.capture.webUnavailableTitle,
                  message: t.capture.webUnavailable,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildMedia(t),
          if (_capturedImage == null && _isCameraReady)
            IgnorePointer(
              child: ValueListenableBuilder<DetectedPose?>(
                valueListenable: _livePose,
                builder: (context, pose, _) =>
                    CustomPaint(painter: PoseGuidePainter(pose: pose)),
              ),
            ),
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: CustomPaint(
                  painter: CornersPainter(theme.colorScheme.primary),
                ),
              ),
            ),
          ),
          if (_capturedImage != null)
            PhotoAlignmentWatcher(
              image: _capturedImage!,
              service: _analysisServiceOrCreate,
              onResult: _onPhotoAnalyzed,
            ),
          SafeArea(
            child: Column(
              children: [
                OverlayHeader(
                  title: t.capture.title,
                  subtitle: t.capture.onDevice,
                  foreground: Colors.white,
                  onBack: Navigator.of(context).canPop()
                      ? () => Navigator.of(context).pop()
                      : null,
                  onInfo: _openInfoSheet,
                ),
                const Spacer(),
                OverlayControls(
                  t: t,
                  isCapturing: _isCapturing,
                  hasCapturedImage: _capturedImage != null,
                  canCapture: _canCapture,
                  onCapture: _captureImage,
                  onRetake: _retakeImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(Translations t) {
    final image = _capturedImage;
    if (image != null) {
      return Image.memory(image, fit: BoxFit.cover, gaplessPlayback: true);
    }
    if (!_isCameraReady) {
      return ColoredBox(
        color: Colors.black,
        child: CameraPlaceholder(
          isLoading: _isInitializing,
          message: _failure == null
              ? _isInitializing
                    ? t.capture.cameraPreparing
                    : t.capture.cameraStartHint
              : '',
          startLabel: t.capture.cameraStart,
          onStart: _failure == null && !_isInitializing
              ? _initializeCamera
              : null,
        ),
      );
    }
    // shortcut: cover-fit por widget; el overlay de pose usa el frame completo,
    // así que en pantallas muy alargadas el esqueleto se desvía del borde.
    final ratio = _camera.previewAspectRatio;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 100,
          height: 100 / ratio,
          child: _camera.buildPreview(),
        ),
      ),
    );
  }

  void _showSnack(
    String message, {
    IconData? icon,
    bool isError = false,
    SnackBarAction? action,
  }) {
    if (!mounted) return;
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isError ? theme.colorScheme.onError : null,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? theme.colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
        // Deja libre el disparador: el aviso no debe tapar el control.
        margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 128),
        duration: const Duration(seconds: 4),
        action: action,
      ),
    );
  }

  void _announceFailure(CaptureCameraFailure failure) {
    final t = Translations.of(context);
    final needsSettings =
        failure == CaptureCameraFailure.permissionPermanentlyDenied ||
        failure == CaptureCameraFailure.permissionRestricted;
    _showSnack(
      _failureMessage(t, failure),
      icon: Icons.videocam_off_outlined,
      isError: true,
      action: SnackBarAction(
        label: needsSettings
            ? t.capture.cameraOpenSettings
            : t.capture.cameraRetry,
        onPressed: needsSettings ? _openCameraSettings : _initializeCamera,
      ),
    );
  }

  /// Un aviso por cambio: mover el cuerpo no debe inundar la pantalla.
  void _announceHint(AlignmentHint? hint) {
    if (hint == null || hint == _lastAnnouncedHint) return;
    _lastAnnouncedHint = hint;
    final (text, icon) = alignmentReadout(Translations.of(context), hint);
    _showSnack(text, icon: icon, isError: hint != AlignmentHint.ok);
  }

  Future<void> _onPhotoAnalyzed(PoseAnalysis result) async {
    final hint = result.alignment;
    final image = _capturedImage;
    if (hint == null || image == null) return;
    // Una revisión por foto: el panel puede reejecutar el análisis.
    if (identical(_analyzedImage, image)) return;
    _analyzedImage = image;

    final t = Translations.of(context);
    final theme = Theme.of(context);
    final (text, icon) = alignmentReadout(t, hint);
    final ok = hint == AlignmentHint.ok;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final retake = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          icon,
          color: ok ? theme.colorScheme.primary : theme.colorScheme.error,
        ),
        title: Text(t.capture.photoResultTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            if (!ok) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                t.capture.alignmentPhotoWarning,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.capture.cameraRetake),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.capture.photoResultKeep),
          ),
        ],
      ),
    );
    if (retake == true) {
      if (mounted) await _retakeImage();
      return;
    }
    if (!mounted) return;
    final choice = await _askBodyMetrics();
    if (choice == null || !mounted) return;
    final metrics = choice.metrics;
    final outcome = const ScreeningService().evaluate(
      result,
      heightCm: metrics?.heightCm,
      weightKg: metrics?.weightKg,
    );
    final onUsePhoto = widget.onUsePhoto;
    if (onUsePhoto != null) {
      onUsePhoto(outcome);
      return;
    }
    context.push('/result', extra: outcome);
  }

  /// Peso y estatura sin los cuales no hay IMC posible. Se piden después de
  /// aceptar la foto y se recuerdan en el dispositivo.
  Future<({BodyMetrics? metrics})?> _askBodyMetrics() async {
    final saved = await _metricsStore.read();
    if (!mounted) return null;
    final choice = await showDialog<({BodyMetrics? metrics})>(
      context: context,
      builder: (context) =>
          BodyMetricsDialog(t: Translations.of(context), initial: saved),
    );
    if (choice?.metrics case final metrics?) await _metricsStore.write(metrics);
    return choice;
  }

  void _openInfoSheet() {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            0,
            AppSpacing.marginMobile,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CriteriaCard(t: t),
              const SizedBox(height: AppSpacing.sm),
              Text(
                t.capture.localNote,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (_capturedImage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                PoseDebugPanel(
                  image: _capturedImage!,
                  service: _analysisServiceOrCreate,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
