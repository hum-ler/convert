import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:convert_unit/widgets/unit_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A pair of [UnitRow]s, one representing the input [Unit], one representing
/// the output [Unit].
class UnitDisplay extends StatelessWidget {
  const UnitDisplay({super.key, required this.units});

  final List<Unit> units;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final inputDisplay = displayInput(
      state.inputBuffer,
      decimalSeparator: state.decimalSeparator,
      insertGroupSeparators: state.insertGroupSeparators,
      groupSeparator: state.groupSeparator,
      integerGroupSize: state.integerGroupSize,
      fractionGroupSize: state.fractionGroupSize,
    );
    final outputDisplay = displayOutput(
      state.inputBuffer,
      inputUnit: state.inputUnit,
      outputUnit: state.outputUnit,
      roundDecimalPlaces: state.outputUnit.precision,
      decimalSeparator: state.decimalSeparator,
      insertGroupSeparator: state.insertGroupSeparators,
      groupSeparator: state.groupSeparator,
      integerGroupSize: state.integerGroupSize,
      fractionGroupSize: state.fractionGroupSize,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UnitRow(
          color: Theme.of(context).colorScheme.primary.withAlpha(159),
          units: units,
          initialIndex: units.indexOf(state.outputUnit),
          value: outputDisplay,
          updateUnit: (state) => state.outputUnit,
          onUnitSelected: (unit) {
            context.read<Controller>().setOutputUnit(unit);
          },
          onValueLongPress: () {
            context.read<Controller>().copyOutputExportToClipboard().then((_) {
              if (context.mounted) {
                showSnackBarMessage(context, '$outputDisplay copied');
              }
            });
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 12.0)),
        UnitRow(
          color: Theme.of(context).colorScheme.primary,
          units: units,
          initialIndex: units.indexOf(state.inputUnit),
          value: inputDisplay,
          updateUnit: (state) => state.inputUnit,
          onUnitSelected: (unit) {
            context.read<Controller>().setInputUnit(unit);
          },
          onValueLongPress: () {
            context.read<Controller>().copyInputExportToClipboard().then((_) {
              if (context.mounted) {
                showSnackBarMessage(context, '$inputDisplay copied');
              }
            });
          },
        ),
      ],
    );
  }
}
