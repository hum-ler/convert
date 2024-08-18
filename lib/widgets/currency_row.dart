import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A row representing a chosen [Currency] and its current [number].
class CurrencyRow extends StatefulWidget {
  const CurrencyRow({
    super.key,
    this.color,
    required this.symbolPosition,
    required this.currency,
    required this.number,
    required this.updateCurrency,
    this.onCurrencySelected,
    this.onNumberLongPress,
  });

  final Color? color;

  final SymbolPosition symbolPosition;

  final Currency currency;

  final String number;

  /// Checks for an updated currency when AppState notifies a change.
  ///
  /// Works around CarouselSlider not responding to initialPage changes.
  final Currency Function(AppState) updateCurrency;

  final void Function(Currency?)? onCurrencySelected;

  final void Function()? onNumberLongPress;

  @override
  State<CurrencyRow> createState() => _CurrencyRowState();
}

class _CurrencyRowState extends State<CurrencyRow> {
  late Currency _currency;

  final _carouselSliderController = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    _currency = widget.currency;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Work around CarouselSlider not updating to initialPage change.
    final state = context.watch<AppState>();

    if (_currency != widget.updateCurrency(state)) {
      _currency = widget.updateCurrency(state);

      if (_carouselSliderController.ready) {
        _carouselSliderController.animateToPage(
          ExchangeRates.toIndex(widget.updateCurrency(state).code),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            height: 40.0,
            width: 120.0,
            child: CarouselSlider(
              items: ExchangeRates.currencies.map((currency) {
                return Text(
                  // The separator is 2 spaces.
                  '${currency.regionEmoji}  ${currency.code}',
                  style: TextStyle(fontSize: 20.0, color: widget.color),
                );
              }).toList(),
              options: CarouselOptions(
                scrollDirection: Axis.vertical,
                height: 40.0,
                viewportFraction: 1.2,
                initialPage: ExchangeRates.toIndex(widget.currency.code),
                onPageChanged: (index, reason) {
                  if (reason == CarouselPageChangedReason.manual) {
                    setState(() => _currency = ExchangeRates.currencies[index]);
                    widget.onCurrencySelected!(ExchangeRates.currencies[index]);
                  }
                },
              ),
              controller: _carouselSliderController,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 12.0)),
          GestureDetector(
            onLongPress: widget.onNumberLongPress,
            child: SizedBox(
              // 156.0 = 12.0 (padding) * 3 + 120.0 (carousel)
              width: MediaQuery.of(context).size.width - 156.0,
              height: 62.0,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.symbolPosition == SymbolPosition.prefix
                        ? widget.currency.symbol + widget.number
                        : widget.number + widget.currency.symbol,
                    textScaler: const TextScaler.linear(4.0),
                    style: TextStyle(color: widget.color),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
