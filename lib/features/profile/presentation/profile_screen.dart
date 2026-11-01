import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_menu.dart';

import '../../../core/providers.dart';
import '../../../i18n/strings.g.dart';
import '../../consent/data/consent_gate.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile.title),
        actions: const [SettingsMenu()],
      ),
      body: ListView(
        children: [
          // Aún sin captura: se muestran deshabilitados en vez de fingir
          // que son editables.
          ListTile(
            enabled: false,
            title: Text(t.profile.height),
            subtitle: Text(t.profile.required),
          ),
          ListTile(
            enabled: false,
            title: Text(t.profile.sex),
            subtitle: Text(t.profile.unset),
          ),
          ListTile(
            enabled: false,
            title: Text(t.profile.age),
            subtitle: Text(t.profile.unset),
          ),
          ListTile(
            title: Text(t.profile.onDevice),
            subtitle: Text(t.profile.onDeviceLocked),
            trailing: const Icon(Icons.lock_outline),
          ),
          ListTile(
            title: Text(t.profile.deleteAll),
            trailing: const Icon(Icons.delete_outline),
            onTap: () => _deleteAll(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.profile.deleteConfirmTitle),
        content: Text(t.profile.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.profile.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.profile.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(measurementStoreProvider).deleteAll();
    // Revocar consentimiento devuelve al usuario a /welcome vía el guard.
    await ref.read(consentGateProvider).revoke();
  }
}
