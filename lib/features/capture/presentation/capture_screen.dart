import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/ui.dart';
import '../../../i18n/strings.g.dart';

/// Captura guiada. La guía (encuadre, inclinación, distancia) es estática por
/// ahora: shortcut: sin pipeline de visión conectado, los valores se alimentan
/// cuando `core/vision` entregue pose + segmentación.
class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                ),
                children: [
                  const _ScanPreview(),
                  const SizedBox(height: AppSpacing.md),
                  _AlignmentCard(t: t, theme: theme),
                  const SizedBox(height: AppSpacing.md),
                  _CriteriaCard(t: t),
                ],
              ),
            ),
            _CaptureBar(t: t),
          ],
        ),
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

/// Marco de escaneo con esquinas y silueta. Sin preview de cámara por ahora.
class _ScanPreview extends StatelessWidget {
  const _ScanPreview();

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
              child: Center(
                child: Icon(
                  Icons.accessibility_new,
                  size: 132,
                  color: theme.colorScheme.primary.withValues(alpha: 0.55),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: CustomPaint(
                  painter: _CornersPainter(theme.colorScheme.primary),
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
  const _CaptureBar({required this.t});

  final Translations t;

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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(t.capture.gallery),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Semantics(
                button: true,
                label: t.capture.shutter,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.timer_outlined, size: 18),
                  label: Text(t.capture.timer),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.capture.shutterPending,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
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
    );
  }
}
