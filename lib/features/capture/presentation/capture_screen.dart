import 'package:flutter/material.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('NutriScan')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Icon(Icons.accessibility_new, size: 96, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Conoce tu rango, no un número',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Estimación por imagen, procesada en tu dispositivo. '
              'Las fotos nunca salen del teléfono.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FilledButton(
              onPressed: null,
              child: const Text('Iniciar medición'),
            ),
            const SizedBox(height: 12),
            Text(
              'Herramienta de tamizaje. No es un diagnóstico médico.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
