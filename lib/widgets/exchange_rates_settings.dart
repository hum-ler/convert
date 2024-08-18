import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The settings for exchange rates.
class ExchangeRatesSettings extends StatelessWidget {
  const ExchangeRatesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    final lastUpdated = ExchangeRates.lastUpdated.toString().split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Exchange rates downloaded on $lastUpdated:'),
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
          onPressed: () => context.read<Controller>().updateExchangeRates(),
          child: const Text(
            'Update exchange rates',
            textScaler: TextScaler.linear(1.2),
          ),
        ),
      ],
    );
  }
}
