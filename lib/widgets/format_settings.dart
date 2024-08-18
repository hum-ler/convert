import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The settings for number format.
class FormatSettings extends StatelessWidget {
  const FormatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: const Text('Insert group separators'),
      value: context.watch<AppState>().insertGroupSeparators,
      onChanged: (value) {
        if (value != null) {
          context.read<Controller>().setInsertGroupSeparators(value);
        }
      },
    );
  }
}
