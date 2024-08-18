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

  String _symbol;

  @override
  String get symbol => _symbol;

  String _name;

  @override
  String get name => _name;

  String _exchangeRate;

  Decimal get exchangeRate => Decimal.parse(_exchangeRate);

  int _precision;

  @override
  int get precision => _precision;

  String _regionEmoji;

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

  void patch({
    String? symbol,
    String? name,
    String? exchangeRate,
    int? precision,
    String? regionEmoji,
  }) {
    if (symbol != null) _symbol = symbol;

    if (name != null) _name = name;

    // Check if exchangeRate can be parsed into a Decimal before setting.
    if (exchangeRate != null && Decimal.tryParse(exchangeRate) != null) {
      _exchangeRate = exchangeRate;
    }

    if (precision != null) _precision = precision;

    if (regionEmoji != null) _regionEmoji = regionEmoji;
  }

  @override
  int compareTo(Currency other) => code.compareTo(other.code);

  @override
  Category get category => Category.currency;

  @override
  Decimal Function(Decimal) get toBaseUnit => toBaseCurrency;

  @override
  Decimal Function(Decimal) get fromBaseUnit => fromBaseCurrency;
}

enum SymbolPosition {
  prefix,
  postfix,
}
