// Implementación con dart:io (móvil/desktop); en web entra el stub.
import 'dart:io';
import 'dart:typed_data';

Future<Uint8List?> readCaptureFile(Future<Uint8List> Function() read) async {
  try {
    return await read();
  } on FileSystemException {
    return null;
  }
}

Future<bool> deleteCaptureFile(String path) async {
  try {
    await File(path).delete();
    return true;
  } on FileSystemException {
    return false;
  }
}
