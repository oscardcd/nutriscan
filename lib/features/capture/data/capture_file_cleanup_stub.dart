// Web capture is disabled, so there is no local temporary file to remove.
import 'dart:typed_data';

Future<Uint8List?> readCaptureFile(Future<Uint8List> Function() read) async =>
    read();

Future<bool> deleteCaptureFile(String path) async => true;
