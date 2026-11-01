import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        children: const [
          ListTile(title: Text('Estatura'), subtitle: Text('Requerida')),
          ListTile(title: Text('Sexo'), subtitle: Text('—')),
          ListTile(title: Text('Edad'), subtitle: Text('—')),
          ListTile(
            title: Text('Procesamiento on-device'),
            subtitle: Text('Activado y bloqueado'),
            trailing: Icon(Icons.lock_outline),
          ),
          ListTile(
            title: Text('Borrar todos los datos'),
            trailing: Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
