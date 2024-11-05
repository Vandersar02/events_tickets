import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notifications
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          const Divider(),

          // Theme
          ListTile(
            title: const Text('Thème'),
            subtitle: const Text('Sélectionner le thème de l\'application'),
            trailing: DropdownButton<String>(
              value: selectedTheme,
              items: <String>['Light', 'Dark'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTheme = newValue!;
                });
              },
            ),
          ),
          const Divider(),

          // Langue
          ListTile(
            title: const Text('Langue'),
            subtitle: const Text('Sélectionner la langue de l\'application'),
            onTap: () {
              // Naviguer vers la page de sélection de la langue
            },
          ),
          const Divider(),

          // À propos
          ListTile(
            title: const Text('À Propos'),
            onTap: () {
              // Naviguer vers la page à propos
            },
          ),
          const Divider(),

          // Déconnexion
          ListTile(
            title: const Text('Déconnexion'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              // Gérer la déconnexion
            },
          ),
        ],
      ),
    );
  }
}
