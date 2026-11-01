import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dev/component_gallery_screen.dart';
import '../../features/capture/presentation/capture_screen.dart';
import '../../features/classify/domain/screening_result.dart';
import '../../features/consent/data/consent_gate.dart';
import '../../features/consent/presentation/consent_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/result/presentation/result_screen.dart';
import '../../i18n/strings.g.dart';

/// El consentimiento es requisito para cualquier pantalla de medición.
GoRouter buildRouter(ConsentGate gate) => GoRouter(
  initialLocation: gate.granted ? '/capture' : '/welcome',
  refreshListenable: gate,
  redirect: (context, state) {
    final path = state.matchedLocation;
    if (kDebugMode && path == '/gallery') return null;
    if (!gate.granted) return path == '/welcome' ? null : '/welcome';
    return path == '/welcome' ? '/capture' : null;
  },
  routes: [
    // Solo desarrollo: galería del design system.
    if (kDebugMode)
      GoRoute(path: '/gallery', builder: (_, _) => const ComponentGalleryScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => const ConsentScreen()),
    // Solo se abre con un resultado real en `extra`: nunca se inventa una
    // medición. Sin pipeline conectada, la ruta cae en /capture.
    GoRoute(
      path: '/result',
      redirect: (_, state) =>
          state.extra is ScreeningResult ? null : '/capture',
      builder: (_, state) =>
          ResultScreen(result: state.extra! as ScreeningResult),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _ShellScaffold(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/capture', builder: (_, _) => const CaptureScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
);

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.camera_alt_outlined),
            selectedIcon: const Icon(Icons.camera_alt),
            label: t.nav.measure,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart_outlined),
            selectedIcon: const Icon(Icons.show_chart),
            label: t.nav.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: t.nav.profile,
          ),
        ],
      ),
    );
  }
}
