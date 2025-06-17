import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The settings for exchange rates.
class ExchangeRatesSettings extends StatefulWidget {
  const ExchangeRatesSettings({super.key});

  @override
  State<ExchangeRatesSettings> createState() => _ExchangeRatesSettingsState();
}

class _ExchangeRatesSettingsState extends State<ExchangeRatesSettings> {
  late final AppState _state;
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();

    _state = context.read<AppState>();
    _state.addListener(_reportLastUpdated);

    _lastUpdated = ExchangeRates.lastUpdated;
  }

  @override
  void dispose() {
    _state.removeListener(_reportLastUpdated);

    super.dispose();
  }

  /// Shows a SnackBar message when the exchange rates are updated.
  void _reportLastUpdated() {
    String updateMessage = 'Exchange rates already up-to-date.';

    if (_lastUpdated != ExchangeRates.lastUpdated) {
      updateMessage =
          'Exchange rates updated to ${ExchangeRates.lastUpdated.toString().split(" ").first}.';
      _lastUpdated = ExchangeRates.lastUpdated;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(updateMessage)));
  }

  @override
  Widget build(BuildContext context) {
    // Triggers an update when currenciesLastUpdated is changed.
    final lastUpdated = context.watch<AppState>().currenciesLastUpdated;

    final scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Exchange rates downloaded on ${lastUpdated.toString().split(" ").first}:',
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: 200.0,
          width: 400.0,
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: scrollController,
              children: ExchangeRates.currencies
                  .where((currency) => currency != ExchangeRates.baseCurrency)
                  .map(
                    (currency) => Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${ExchangeRates.baseCurrency.code}/${currency.code}',
                              textScaler: const TextScaler.linear(1.2),
                            ),
                          ),
                        ),
                        const Text(' = ', textScaler: TextScaler.linear(1.2)),
                        Expanded(
                          child: Text(
                            '${currency.exchangeRate}',
                            textScaler: const TextScaler.linear(1.2),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        FilledButton(
          onPressed: () => context
              .read<Controller>()
              .updateExchangeRates(context)
              .catchError((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Unable to download latest exchange rates. Please try again later.',
                  ),
                ),
              );
            }
          }),
          child: const Text(
            'Sign in | Update',
            textScaler: TextScaler.linear(1.2),
          ),
        ),
      ],
    );
  }
}
