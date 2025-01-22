import 'dart:convert';

import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:decimal/decimal.dart';

/// A monetary [Currency].
class Currency implements Comparable<Currency>, Unit {
  Currency({
    required this.code,
    required String symbol,
    required String name,
    required String exchangeRate,
    required int precision,
    required String regionEmoji,
  })  : _symbol = symbol,
        _name = name,
        _exchangeRate = exchangeRate,
        _precision = precision,
        _regionEmoji = regionEmoji;

  @override
  final String code;

  final String _symbol;

  @override
  String get symbol => _symbol;

  final String _name;

  @override
  String get name => _name;

  final String _exchangeRate;

  Decimal get exchangeRate => Decimal.parse(_exchangeRate);

  final int _precision;

  @override
  int get precision => _precision;

  final String _regionEmoji;

  String get regionEmoji => _regionEmoji;

  Decimal Function(Decimal) get toBaseCurrency {
    return (value) {
      return value *
          exchangeRate.inverse.toDecimal(scaleOnInfinitePrecision: 15);
    };
  }

  Decimal Function(Decimal) get fromBaseCurrency {
    return (value) => value * exchangeRate;
  }

  @override
  int compareTo(Currency other) => code.compareTo(other.code);

  @override
  Category get category => Category.currency;

  @override
  Decimal Function(Decimal) get toBaseUnit => toBaseCurrency;

  @override
  Decimal Function(Decimal) get fromBaseUnit => fromBaseCurrency;

  /// Converts a [Currency] to a serializable string.
  static String toJson(Currency currency) =>
      '{"code":"${currency.code}","symbol":"${currency.symbol}","name":"${currency.name}","exchange-rate":"${currency.exchangeRate}","precision":${currency.precision},"region-emoji":"${currency.regionEmoji}"}';

  /// Converts a serializable string to a [Currency].
  static Currency? fromJson(String json) {
    final parsedCurrency = jsonDecode(json);

    if (parsedCurrency['code'] == null ||
        parsedCurrency['symbol'] == null ||
        parsedCurrency['name'] == null ||
        parsedCurrency['exchange-rate'] == null ||
        parsedCurrency['precision'] == null ||
        parsedCurrency['region-emoji'] == null) {
      return null;
    }

    return Currency(
      code: parsedCurrency['code'],
      symbol: parsedCurrency['symbol'],
      name: parsedCurrency['name'],
      exchangeRate: parsedCurrency['exchange-rate'],
      precision: parsedCurrency['precision'],
      regionEmoji: parsedCurrency['region-emoji'],
    );
  }
}

enum SymbolPosition {
  prefix,
  postfix,
}
