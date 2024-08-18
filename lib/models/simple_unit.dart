import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:decimal/decimal.dart';

/// A simple linear conversion [Unit] that starts from 0.
class SimpleUnit implements Unit {
  const SimpleUnit({
    required this.category,
    required this.code,
    required this.name,
    required this.precision,
    required this.symbol,
    required this.factor,
  });

  @override
  final Category category;

  @override
  final String code;

  @override
  final String name;

  @override
  final int precision;

  @override
  final String symbol;

  final String factor;

  @override
  Decimal Function(Decimal) get toBaseUnit {
    return (value) => value * Decimal.parse(factor);
  }

  @override
  Decimal Function(Decimal) get fromBaseUnit {
    return (value) {
      return value *
          Decimal.parse(factor).inverse.toDecimal(scaleOnInfinitePrecision: 15);
    };
  }
}
