import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        value: context.watch<ThemeProvider>().isDark,
        onChanged: (_) => context.read<ThemeProvider>().toggle(),
      ),
    );
  }
}