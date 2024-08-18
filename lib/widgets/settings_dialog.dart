import 'package:convert_unit/widgets/color_settings.dart';
import 'package:convert_unit/widgets/exchange_rates_settings.dart';
import 'package:convert_unit/widgets/format_settings.dart';
import 'package:convert_unit/widgets/mode_settings.dart';
import 'package:flutter/material.dart';

/// A dialog box for changing the app settings / options.
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      contentPadding: EdgeInsets.all(12.0),
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
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        child,
      ],
    );
  }
}
