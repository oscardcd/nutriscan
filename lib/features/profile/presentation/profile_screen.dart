import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.profile.title)),
      body: ListView(
        children: [
          ListTile(title: Text(t.profile.height), subtitle: Text(t.profile.required)),
          ListTile(title: Text(t.profile.sex), subtitle: Text(t.profile.unset)),
          ListTile(title: Text(t.profile.age), subtitle: Text(t.profile.unset)),
          ListTile(
            title: Text(t.profile.onDevice),
            subtitle: Text(t.profile.onDeviceLocked),
            trailing: const Icon(Icons.lock_outline),
          ),
          ListTile(
            title: Text(t.profile.deleteAll),
            trailing: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
