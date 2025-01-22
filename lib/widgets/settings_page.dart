import 'package:convert_unit/widgets/color_settings.dart';
import 'package:convert_unit/widgets/exchange_rates_settings.dart';
import 'package:convert_unit/widgets/format_settings.dart';
import 'package:convert_unit/widgets/mode_settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Row(
          children: [
            Text('Settings'),
            SizedBox(width: 4.0),
            Icon(Icons.settings),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            SettingsSection(
              title: 'Exchange rates',
              child: ExchangeRatesSettings(),
            ),
            SizedBox(height: 12.0),
            SettingsSection(title: 'Format', child: FormatSettings()),
            SizedBox(height: 12.0),
            SettingsSection(title: 'Mode', child: ModeSettings()),
            SizedBox(height: 12.0),
            SettingsSection(title: 'Color', child: ColorSettings()),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.child});

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.inversePrimary.withAlpha(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: child,
        ),
      ],
    );
  }
}
