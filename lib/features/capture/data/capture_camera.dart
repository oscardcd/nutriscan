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

abstract interface class CaptureCamera {
  Future<void> initialize();

  Widget buildPreview();

  Future<Uint8List> takePicture();

  Future<bool> openSettings();

  Future<void> dispose();
}

class DeviceCaptureCamera implements CaptureCamera {
  CameraController? _controller;
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
  Widget buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('La cámara debe estar inicializada para mostrarla.');
    }
    return CameraPreview(controller);
  }

  @override
  Future<Uint8List> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const CaptureCameraException(CaptureCameraFailure.unavailable);
    }

    try {
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
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  Future<void> _discard(CameraController? controller) async {
    if (controller == null) return;
    if (!identical(_controller, controller)) return;
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
