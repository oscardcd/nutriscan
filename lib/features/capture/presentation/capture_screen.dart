import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/ui.dart';
import '../../../i18n/strings.g.dart';
import '../../vision/presentation/pose_debug_panel_stub.dart'
    if (dart.library.io) '../../vision/presentation/pose_debug_panel.dart';
import '../data/capture_camera.dart';

const _captureTimeout = Duration(seconds: 30);

/// Captura guiada. La guía (encuadre, inclinación, distancia) es estática por
/// ahora: shortcut: sin pipeline de visión conectado, los valores se alimentan
/// cuando `core/vision` entregue pose + segmentación.
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, this.visionAvailable = !kIsWeb, this.camera});

  /// Cámara y modelos de visión (ML Kit, TFLite) solo existen en móvil.
  final bool visionAvailable;
  final CaptureCamera? camera;

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
      unawaited(
        _disposeCameraAfterPreviewRemoved(
          _operationId,
          onlyWhenPaused: true,
        ),
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
    } on CaptureCameraException catch (error) {
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = error.failure);
      }
    } on CameraException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = CaptureCameraFailure.unavailable);
      }
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted && _isAppResumed) {
        setState(() => _failure = CaptureCameraFailure.unavailable);
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
      await _disposeCameraAfterPreviewRemoved(operationId);
    } on CaptureCameraException catch (error) {
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = error.failure;
        });
      }
    } on TimeoutException {
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
      }
    } on CameraException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
      }
    } on PlatformException catch (error, stackTrace) {
      _reportCameraError(error, stackTrace);
      if (operationId == _operationId && mounted) {
        setState(() {
          _isCameraReady = false;
          _failure = CaptureCameraFailure.captureFailed;
        });
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
    WidgetsBinding.instance.removeObserver(this);
    _capturedImage?.fillRange(0, _capturedImage!.length, 0);
    unawaited(_disposeCamera());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(title: t.capture.title),
            if (!widget.visionAvailable)
              Expanded(
                child: EmptyState(
                  icon: Icons.no_photography_outlined,
                  title: t.capture.webUnavailableTitle,
                  message: t.capture.webUnavailable,
                ),
              )
            else ...[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    AppSpacing.md,
                    AppSpacing.marginMobile,
                    AppSpacing.md,
                  ),
                  children: [
                    _ScanPreview(
                      child: _capturedImage != null
                          ? Image.memory(
                              _capturedImage!,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            )
                          : _isCameraReady
                          ? _camera.buildPreview()
                          : _CameraPlaceholder(
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
                    ),
                    if (_failure != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _CameraError(
                        message: _failureMessage(t, _failure!),
                        actionLabel:
                            _failure ==
                                    CaptureCameraFailure
                                        .permissionPermanentlyDenied ||
                                _failure ==
                                    CaptureCameraFailure.permissionRestricted
                            ? t.capture.cameraOpenSettings
                            : t.capture.cameraRetry,
                        onPressed:
                            _failure ==
                                    CaptureCameraFailure
                                        .permissionPermanentlyDenied ||
                                _failure ==
                                    CaptureCameraFailure.permissionRestricted
                            ? _openCameraSettings
                            : _initializeCamera,
                      ),
                    ],
                    if (_capturedImage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        t.capture.cameraCaptured,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (widget.visionAvailable) ...[
                        const SizedBox(height: AppSpacing.sm),
                        PoseDebugPanel(image: _capturedImage!),
                      ],
                    ],
                    const SizedBox(height: AppSpacing.md),
                    _AlignmentCard(t: t, theme: theme),
                    const SizedBox(height: AppSpacing.md),
                    _CriteriaCard(t: t),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      t.capture.localNote,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              _CaptureBar(
                t: t,
                canCapture: _isCameraReady && !_isCapturing,
                isCapturing: _isCapturing,
                hasCapturedImage: _capturedImage != null,
                onCapture: _captureImage,
                onRetake: _retakeImage,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder({
    required this.isLoading,
    required this.message,
    required this.startLabel,
    this.onStart,
  });

  final bool isLoading;
  final String message;
  final String startLabel;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              Icon(
                Icons.photo_camera_outlined,
                size: 44,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message, textAlign: TextAlign.center),
            ],
            if (onStart != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(startLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: onPressed, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                Text(
                  Translations.of(context).capture.onDevice,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanPreview extends StatelessWidget {
  const _ScanPreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.container),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.container),
                child: child,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: CustomPaint(
                    painter: _CornersPainter(theme.colorScheme.primary),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: StatusPill(
                text: Translations.of(context).capture.localBadge,
                icon: Icons.lock_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  _CornersPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    const arm = 24.0;
    const radius = 8.0;

    void corner(Offset origin, double dx, double dy) {
      final path = Path()
        ..moveTo(origin.dx, origin.dy + dy * arm)
        ..lineTo(origin.dx, origin.dy + dy * radius)
        ..quadraticBezierTo(
          origin.dx,
          origin.dy,
          origin.dx + dx * radius,
          origin.dy,
        )
        ..lineTo(origin.dx + dx * arm, origin.dy);
      canvas.drawPath(path, paint);
    }

    corner(Offset.zero, 1, 1);
    corner(Offset(size.width, 0), -1, 1);
    corner(Offset(0, size.height), 1, -1);
    corner(Offset(size.width, size.height), -1, -1);
  }

  @override
  bool shouldRepaint(_CornersPainter oldDelegate) => oldDelegate.color != color;
}

class _AlignmentCard extends StatelessWidget {
  const _AlignmentCard({required this.t, required this.theme});

  final Translations t;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(t.capture.alignment),
          const SizedBox(height: AppSpacing.sm),
          // Guía estática: hasta que exista la pipeline no se muestra ninguna
          // lectura (ni ángulos ni distancias) que no se haya medido.
          _AlignmentRow(icon: Icons.verified_outlined, text: t.capture.posture),
          _AlignmentRow(
            icon: Icons.screen_rotation_outlined,
            text: t.capture.tilt,
          ),
          _AlignmentRow(
            icon: Icons.filter_center_focus,
            text: t.capture.sensor,
          ),
          _AlignmentRow(icon: Icons.straighten, text: t.capture.distance),
        ],
      ),
    );
  }
}

class _AlignmentRow extends StatelessWidget {
  const _AlignmentRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  const _CriteriaCard({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(t.capture.criteria),
          const SizedBox(height: AppSpacing.sm),
          ScanCriterion(label: t.capture.fullBody),
          ScanCriterion(label: t.capture.twoMeters),
          ScanCriterion(
            label: t.capture.plainBackground,
            icon: Icons.info_outline,
            ok: false,
          ),
          ScanCriterion(
            label: t.capture.looseClothing,
            icon: Icons.info_outline,
            ok: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.threesixty,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.capture.sideView,
                        style: theme.textTheme.labelLarge,
                      ),
                      Text(
                        t.capture.sideViewHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureBar extends StatelessWidget {
  const _CaptureBar({
    required this.t,
    required this.canCapture,
    required this.isCapturing,
    required this.hasCapturedImage,
    required this.onCapture,
    required this.onRetake,
  });

  final Translations t;
  final bool canCapture;
  final bool isCapturing;
  final bool hasCapturedImage;
  final VoidCallback onCapture;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        AppSpacing.md,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          final captureButton = IconButton.filled(
            onPressed: isCapturing
                ? null
                : hasCapturedImage
                ? onRetake
                : canCapture
                ? onCapture
                : null,
            tooltip: hasCapturedImage
                ? t.capture.cameraRetake
                : t.capture.shutter,
            style: IconButton.styleFrom(
              fixedSize: const Size(64, 64),
              backgroundColor: theme.colorScheme.primary,
            ),
            icon: isCapturing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(hasCapturedImage ? Icons.refresh : Icons.camera_alt),
          );
          final galleryButton = compact
              ? IconButton(
                  onPressed: null,
                  tooltip: t.capture.gallery,
                  icon: const Icon(Icons.photo_library_outlined),
                )
              : Expanded(
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: Text(t.capture.gallery),
                  ),
                );
          final timerButton = compact
              ? IconButton(
                  onPressed: null,
                  tooltip: t.capture.timer,
                  icon: const Icon(Icons.timer_outlined),
                )
              : Expanded(
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.timer_outlined, size: 18),
                    label: Text(t.capture.timer),
                  ),
                );

          return Row(
            children: [
              galleryButton,
              const SizedBox(width: AppSpacing.sm),
              captureButton,
              const SizedBox(width: AppSpacing.sm),
              timerButton,
            ],
          );
        },
      ),
    );
  }
}
