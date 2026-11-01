import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';

/// Tema elegido por el usuario. `system` respeta la preferencia del SO.
/// shortcut: vive en memoria, se pierde al reiniciar hasta que haya storage de ajustes.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Idioma de la interfaz. Cambiar aquí reconstruye toda la app vía slang.
class LocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() => LocaleSettings.currentLocale;

  void set(AppLocale locale) {
    LocaleSettings.setLocale(locale);
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(
  LocaleNotifier.new,
);
