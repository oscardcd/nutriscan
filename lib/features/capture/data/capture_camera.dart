import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'capture_file_cleanup_stub.dart'
    if (dart.library.io) 'capture_file_cleanup_io.dart'
    as file_cleanup;

enum CaptureCameraFailure {
  permissionDenied,
  permissionPermanentlyDenied,
  permissionRestricted,
  noCamera,
  unavailable,
  captureFailed,
  interrupted,
}

class CaptureCameraException implements Exception {
  const CaptureCameraException(this.failure);

  final CaptureCameraFailure failure;
}

/// Plano crudo de un frame del image stream.
class CameraFramePlane {
  const CameraFramePlane({
    required this.bytes,
    required this.bytesPerRow,
    required this.bytesPerPixel,
  });

  final Uint8List bytes;
  final int bytesPerRow;
  final int bytesPerPixel;
}

/// Frame del image stream en yuv420, listo para el detector de pose.
class CameraFrame {
  const CameraFrame({
    required this.planes,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.format,
  });

  final List<CameraFramePlane> planes;
  final int width;
  final int height;
  final int rotationDegrees;

  /// 'yuv420' o 'bgra8888', según lo que entregue el image stream.
  final String format;
}

abstract interface class CaptureCamera {
  Future<void> initialize();

  Widget buildPreview();

  /// Ancho/alto del preview tal como se ve en pantalla (vertical en iOS).
  double get previewAspectRatio;

  /// Frames del image stream. Se detiene con [stopStream] o al capturar.
  Stream<CameraFrame> startStream();

  Future<void> stopStream();

  Future<Uint8List> takePicture();

  Future<bool> openSettings();

  Future<void> dispose();
}

class DeviceCaptureCamera implements CaptureCamera {
  CameraController? _controller;
  StreamController<CameraFrame>? _frames;
  int _generation = 0;

  @override
  Future<void> initialize() async {
    final generation = ++_generation;
    final previousController = _controller;
    _controller = null;
    CameraController? controller;

    try {
      await previousController?.dispose();
      if (generation != _generation) {
        throw const CaptureCameraException(CaptureCameraFailure.interrupted);
      }

      var permission = await Permission.camera.status;
      if (permission.isPermanentlyDenied) {
        throw const CaptureCameraException(
          CaptureCameraFailure.permissionPermanentlyDenied,
        );
      }
      if (permission.isRestricted) {
        throw const CaptureCameraException(
          CaptureCameraFailure.permissionRestricted,
        );
      }
      if (!permission.isGranted) {
        permission = await Permission.camera.request();
      }
      if (generation != _generation) {
        throw const CaptureCameraException(CaptureCameraFailure.interrupted);
      }
      if (permission.isPermanentlyDenied) {
        throw const CaptureCameraException(
          CaptureCameraFailure.permissionPermanentlyDenied,
        );
      }
      if (permission.isRestricted) {
        throw const CaptureCameraException(
          CaptureCameraFailure.permissionRestricted,
        );
      }
      if (!permission.isGranted) {
        throw const CaptureCameraException(
          CaptureCameraFailure.permissionDenied,
        );
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw const CaptureCameraException(CaptureCameraFailure.noCamera);
      }
      if (generation != _generation) {
        throw const CaptureCameraException(CaptureCameraFailure.interrupted);
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        // bgra8888 es el formato que MediaPipe espera en iOS; con yuv420
        // el plugin entrega landmarks degenerados.
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      _controller = controller;
      await controller.initialize();

      if (generation != _generation) {
        throw const CaptureCameraException(CaptureCameraFailure.interrupted);
      }
    } on CaptureCameraException {
      await _discard(controller);
      rethrow;
    } on CameraException catch (error) {
      await _discard(controller);
      throw CaptureCameraException(_failureForCameraCode(error.code));
    } on PlatformException {
      await _discard(controller);
      throw const CaptureCameraException(CaptureCameraFailure.unavailable);
    } on MissingPluginException {
      await _discard(controller);
      throw const CaptureCameraException(CaptureCameraFailure.unavailable);
    }
  }

  @override
  double get previewAspectRatio {
    final value = _controller?.value;
    if (value == null || !value.isInitialized) return 3 / 4;
    // En iOS el sensor reporta apaisado (16:9); en pantalla se ve vertical.
    return value.aspectRatio > 1 ? 1 / value.aspectRatio : value.aspectRatio;
  }

  @override
  Widget buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('La cámara debe estar inicializada para mostrarla.');
    }
    return CameraPreview(controller);
  }

  /// El plugin de pose arma el NV21 con ancho*alto y asume filas sin padding.
  /// Android entrega bytesPerRow > ancho (720 → 768), así que se recortan las
  /// filas antes de enviarlas: sin esto la conversión nativa revienta.
  List<CameraFramePlane> _planesFor(CameraImage image) {
    if (image.format.group != ImageFormatGroup.yuv420) {
      return [
        for (final plane in image.planes)
          CameraFramePlane(
            bytes: plane.bytes,
            bytesPerRow: plane.bytesPerRow,
            bytesPerPixel: plane.bytesPerPixel ?? 1,
          ),
      ];
    }
    return [
      for (var i = 0; i < image.planes.length; i++) _trimPlane(image, i),
    ];
  }

  CameraFramePlane _trimPlane(CameraImage image, int index) {
    final plane = image.planes[index];
    final pixelBytes = plane.bytesPerPixel ?? 1;
    final rowBytes = (index == 0 ? image.width : image.width ~/ 2) * pixelBytes;
    final rows = index == 0 ? image.height : image.height ~/ 2;
    if (plane.bytesPerRow == rowBytes) {
      return CameraFramePlane(
        bytes: plane.bytes,
        bytesPerRow: plane.bytesPerRow,
        bytesPerPixel: pixelBytes,
      );
    }
    final trimmed = Uint8List(rowBytes * rows);
    for (var row = 0; row < rows; row++) {
      final start = row * plane.bytesPerRow;
      final available = plane.bytes.length - start;
      if (available <= 0) break;
      final take = rowBytes < available ? rowBytes : available;
      trimmed.setRange(row * rowBytes, row * rowBytes + take, plane.bytes, start);
    }
    return CameraFramePlane(
      bytes: trimmed,
      bytesPerRow: rowBytes,
      bytesPerPixel: pixelBytes,
    );
  }

  @override
  Stream<CameraFrame> startStream() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('La cámara debe estar inicializada para transmitir.');
    }
    unawaited(_detachFrames());

    final frames = StreamController<CameraFrame>.broadcast();
    _frames = frames;
    final rotation = controller.description.sensorOrientation;

    unawaited(
      controller
          .startImageStream((image) {
            if (frames.isClosed) return;
            frames.add(
              CameraFrame(
                planes: _planesFor(image),
                width: image.width,
                height: image.height,
                rotationDegrees: rotation,
                format: image.format.group == ImageFormatGroup.yuv420
                    ? 'yuv420'
                    : 'bgra8888',
              ),
            );
          })
          .catchError((Object error) {
            if (!frames.isClosed) frames.addError(error);
          }),
    );
    return frames.stream;
  }

  @override
  Future<void> stopStream() async {
    await _detachFrames();
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (!controller.value.isStreamingImages) return;
    await controller.stopImageStream();
  }

  @override
  Future<Uint8List> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const CaptureCameraException(CaptureCameraFailure.unavailable);
    }

    try {
      // iOS no captura mientras el image stream está activo.
      await stopStream();
      final file = await controller.takePicture();
      late final Uint8List bytes;
      try {
        final content = await file_cleanup.readCaptureFile(file.readAsBytes);
        if (content == null) {
          throw const CaptureCameraException(
            CaptureCameraFailure.captureFailed,
          );
        }
        bytes = content;
      } finally {
        final deleted = await file_cleanup.deleteCaptureFile(file.path);
        if (!deleted) {
          throw const CaptureCameraException(
            CaptureCameraFailure.captureFailed,
          );
        }
      }
      return bytes;
    } on CaptureCameraException {
      rethrow;
    } on CameraException {
      throw const CaptureCameraException(CaptureCameraFailure.captureFailed);
    } on PlatformException {
      throw const CaptureCameraException(CaptureCameraFailure.captureFailed);
    }
  }

  @override
  Future<bool> openSettings() => openAppSettings();

  @override
  Future<void> dispose() async {
    _generation++;
    await _detachFrames();
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  Future<void> _detachFrames() async {
    final frames = _frames;
    _frames = null;
    if (frames != null && !frames.isClosed) await frames.close();
  }

  Future<void> _discard(CameraController? controller) async {
    if (controller == null) return;
    if (!identical(_controller, controller)) return;
    await _detachFrames();
    _controller = null;
    await controller.dispose();
  }

  CaptureCameraFailure _failureForCameraCode(String code) => switch (code) {
    'CameraAccessDenied' => CaptureCameraFailure.permissionDenied,
    'CameraAccessDeniedWithoutPrompt' =>
      CaptureCameraFailure.permissionPermanentlyDenied,
    'CameraAccessRestricted' => CaptureCameraFailure.permissionRestricted,
    _ => CaptureCameraFailure.unavailable,
  };
}
