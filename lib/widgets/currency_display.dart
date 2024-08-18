import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:convert_unit/widgets/currency_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A pair of [CurrencyRow]s, one for output [Currency], one for input
/// [Currency].
class CurrencyDisplay extends StatelessWidget {
  const CurrencyDisplay({super.key});

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
        CurrencyRow(
          key: const Key('output-currency-row'),
          color: Theme.of(context).colorScheme.primary.withAlpha(159),
          symbolPosition: state.currencySymbolPosition,
          currency: state.outputUnit as Currency,
          number: outputDisplay,
          updateCurrency: (state) => state.outputUnit as Currency,
          onCurrencySelected: (currency) {
            context.read<Controller>().setOutputUnit(currency);
          },
          onNumberLongPress: () {
            context.read<Controller>().copyOutputExportToClipboard().then((_) {
              if (context.mounted) {
                showSnackBarMessage(context, '$outputDisplay copied');
              }
            });
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 12.0)),
        CurrencyRow(
          key: const Key('input-currency-row'),
          color: Theme.of(context).colorScheme.primary,
          symbolPosition: state.currencySymbolPosition,
          currency: state.inputUnit as Currency,
          number: inputDisplay,
          updateCurrency: (state) => state.inputUnit as Currency,
          onCurrencySelected: (currency) {
            context.read<Controller>().setInputUnit(currency);
          },
          onNumberLongPress: () {
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
