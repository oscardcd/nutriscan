import 'package:go_router/go_router.dart';

import '../../features/capture/presentation/capture_screen.dart';
import '../../features/classify/domain/screening_outcome.dart';
import '../../features/consent/data/consent_gate.dart';
import '../../features/consent/presentation/consent_screen.dart';
import '../../features/result/presentation/result_screen.dart';

/// El consentimiento es requisito para cualquier pantalla de medición.
GoRouter buildRouter(ConsentGate gate) => GoRouter(
  initialLocation: gate.granted ? '/capture' : '/welcome',
  refreshListenable: gate,
  redirect: (context, state) {
    final path = state.matchedLocation;
    if (!gate.granted) return path == '/welcome' ? null : '/welcome';
    return path == '/welcome' ? '/capture' : null;
  },
  routes: [
    GoRoute(path: '/welcome', builder: (_, _) => const ConsentScreen()),
    // Solo se abre con un desenlace real en `extra` (predicción o abstención):
    // nunca se inventa una medición. Sin desenlace, la ruta cae en /capture.
    GoRoute(
      path: '/result',
      redirect: (_, state) =>
          state.extra is ScreeningOutcome ? null : '/capture',
      builder: (_, state) =>
          ResultScreen(outcome: state.extra! as ScreeningOutcome),
    ),
    GoRoute(path: '/capture', builder: (_, _) => const CaptureScreen()),
  ],
);
