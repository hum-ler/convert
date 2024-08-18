import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:decimal/decimal.dart';

/// A temperature [Unit].
class Temperature implements Unit {
  const Temperature({
    required this.code,
    required this.name,
    required this.symbol,
    required this.toBaseUnit,
    required this.fromBaseUnit,
  });

  @override
  final String code;

  @override
  final category = Category.temperature;

  @override
  final precision = 1;

  @override
  final String name;

  @override
  final String symbol;

  @override
  final Decimal Function(Decimal) toBaseUnit;

  @override
  final Decimal Function(Decimal) fromBaseUnit;
}
