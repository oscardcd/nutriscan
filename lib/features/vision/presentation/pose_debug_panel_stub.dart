import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Web no soporta detección de pose: el panel no se renderiza.
class PoseDebugPanel extends StatelessWidget {
  const PoseDebugPanel({super.key, required this.image});

  final Uint8List image;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
