import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dev/component_gallery_screen.dart';
import '../../features/capture/presentation/capture_screen.dart';
import '../../features/consent/presentation/consent_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/classify/domain/screening_result.dart';
import '../../features/result/presentation/result_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../i18n/strings.g.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    // Solo desarrollo: galería del design system.
    GoRoute(path: '/gallery', builder: (_, _) => const ComponentGalleryScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => const ConsentScreen()),
    // shortcut: valores de ejemplo hasta conectar la pipeline de medición.
    GoRoute(
      path: '/result',
      builder: (_, _) => const ResultScreen(
        result: ScreeningResult(
          bmi: 27.4,
          margin: 1.8,
          confidence: ScreeningConfidence.high,
          waistToHeight: 0.53,
          bodyRoundness: 3.8,
          relativeFatMass: 26.4,
        ),
      ),
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
