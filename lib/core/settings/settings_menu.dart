import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';
import 'settings_providers.dart';

/// Menú de idioma y tema para el app bar.
class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final locale = ref.watch(localeProvider);
    final currentMode = ref.watch(themeModeProvider);

    return PopupMenuButton<Object>(
      icon: const Icon(Icons.tune),
      tooltip: t.settings.title,
      onSelected: (value) {
        if (value is AppLocale) ref.read(localeProvider.notifier).set(value);
        if (value is ThemeMode) ref.read(themeModeProvider.notifier).set(value);
      },
      itemBuilder: (context) => [
        _label(context, t.settings.language),
        for (final l in AppLocale.values)
          CheckedPopupMenuItem<Object>(
            value: l,
            checked: locale == l,
            child: Text(_localeName(l)),
          ),
        const PopupMenuDivider(),
        _label(context, t.settings.theme),
        for (final entry in {
          ThemeMode.system: t.settings.themeSystem,
          ThemeMode.light: t.settings.themeLight,
          ThemeMode.dark: t.settings.themeDark,
        }.entries)
          CheckedPopupMenuItem<Object>(
            value: entry.key,
            checked: currentMode == entry.key,
            child: Text(entry.value),
          ),
      ],
    );
  }

  PopupMenuEntry<Object> _label(BuildContext context, String text) =>
      PopupMenuItem<Object>(
        enabled: false,
        height: 32,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
      );

  String _localeName(AppLocale locale) => switch (locale) {
    AppLocale.es => 'Español',
    AppLocale.en => 'English',
  };
}
