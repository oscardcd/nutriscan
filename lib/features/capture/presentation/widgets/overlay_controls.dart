import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

class OverlayControls extends StatelessWidget {
  const OverlayControls({
    super.key,
    required this.t,
    required this.isCapturing,
    required this.hasCapturedImage,
    required this.canCapture,
    required this.onCapture,
    required this.onRetake,
  });

  final Translations t;
  final bool isCapturing;
  final bool hasCapturedImage;
  final bool canCapture;
  final VoidCallback onCapture;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final enabled = hasCapturedImage || canCapture;
    final action = isCapturing
        ? null
        : hasCapturedImage
        ? onRetake
        : canCapture
        ? onCapture
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Tooltip(
          message: hasCapturedImage
              ? t.capture.cameraRetake
              : t.capture.shutter,
          child: Semantics(
            button: true,
            label: hasCapturedImage
                ? t.capture.cameraRetake
                : t.capture.shutter,
            child: GestureDetector(
              onTap: action,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: enabled
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                    ),
                    child: isCapturing
                        ? const Padding(
                            padding: EdgeInsets.all(18),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black54,
                            ),
                          )
                        : const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
