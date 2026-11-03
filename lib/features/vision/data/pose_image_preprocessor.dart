import 'dart:typed_data';

import 'package:image/image.dart' as img;

const maxPoseImageBytes = 15 * 1024 * 1024;
const maxPoseImagePixels = 12 * 1024 * 1024;

enum PoseImagePreparationFailure { invalidImage, imageTooLarge }

class PreparedPoseImage {
  const PreparedPoseImage({
    required this.bytes,
    required this.width,
    required this.height,
  }) : failure = null;

  final Uint8List? bytes;
  final int width;
  final int height;
  final PoseImagePreparationFailure? failure;

  const PreparedPoseImage.failed(PoseImagePreparationFailure this.failure)
    : bytes = null,
      width = 0,
      height = 0;
}

PreparedPoseImage preparePoseImage(Uint8List bytes) {
  if (bytes.length > maxPoseImageBytes) {
    return const PreparedPoseImage.failed(
      PoseImagePreparationFailure.imageTooLarge,
    );
  }

  final decoder = img.findDecoderForData(bytes);
  if (decoder == null ||
      (decoder is! img.JpegDecoder && decoder is! img.PngDecoder)) {
    return const PreparedPoseImage.failed(
      PoseImagePreparationFailure.invalidImage,
    );
  }
  try {
    final info = decoder.startDecode(bytes);
    if (info == null || info.width <= 0 || info.height <= 0) {
      return const PreparedPoseImage.failed(
        PoseImagePreparationFailure.invalidImage,
      );
    }
    if (info.width * info.height > maxPoseImagePixels) {
      return const PreparedPoseImage.failed(
        PoseImagePreparationFailure.imageTooLarge,
      );
    }

    final decoded = decoder.decodeFrame(0);
    if (decoded == null) {
      return const PreparedPoseImage.failed(
        PoseImagePreparationFailure.invalidImage,
      );
    }

    final oriented = img.bakeOrientation(decoded);
    return PreparedPoseImage(
      bytes: img.encodeJpg(oriented, quality: 90),
      width: oriented.width,
      height: oriented.height,
    );
  } on img.ImageException {
    return const PreparedPoseImage.failed(
      PoseImagePreparationFailure.invalidImage,
    );
  }
}
