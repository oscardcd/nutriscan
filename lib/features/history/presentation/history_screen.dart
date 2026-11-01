import 'package:flutter/material.dart';
import '../../../core/settings/settings_menu.dart';

import '../../../i18n/strings.g.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.history.title),
        actions: const [SettingsMenu()],
      ),
      body: Center(child: Text(t.history.empty)),
    );
  }
}
