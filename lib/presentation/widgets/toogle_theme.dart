import 'package:events_ticket/data/providers/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        value: themeProvider.themeMode == ThemeMode.dark,
        onChanged: (value) {
          themeProvider.toggleTheme(value); // Toggle between dark and light
        },
      ),
    );
  }
}
