import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';
import 'package:convert_unit/models/unit.dart';

/// The collection of time [SimpleUnit]s.
class TimeUnits {
  static const units = [
    SimpleUnit(
      category: Category.time,
      code: 'd',
      name: 'day',
      precision: 6,
      symbol: 'd',
      factor: '86400',
    ),
    SimpleUnit(
      category: Category.time,
      code: 'h',
      name: 'hour',
      precision: 6,
      symbol: 'h',
      factor: '3600',
    ),
    SimpleUnit(
      category: Category.time,
      code: 'm',
      name: 'minute',
      precision: 4,
      symbol: 'm',
      factor: '60',
    ),
    SimpleUnit(
      category: Category.time,
      code: 's',
      name: 'second',
      precision: 3,
      symbol: 's',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.time,
      code: 'ms',
      name: 'millisecond',
      precision: 0,
      symbol: 'ms',
      factor: '0.001',
    ),
  ];

  static final _baseUnit = fromCode('s');

  static SimpleUnit get baseUnit => _baseUnit;

  static UnitPair get defaultUnits =>
      (inputUnit: _baseUnit, outputUnit: fromCode('h'));

  static SimpleUnit fromCode(String code) {
    return units.firstWhere((unit) => unit.code == code);
  }

  static SimpleUnit? tryFromCode(String code) {
    try {
      return fromCode(code);
    } on StateError {
      return null;
    }
  }
}
