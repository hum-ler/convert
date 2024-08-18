import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';

/// The collection of speed [SimpleUnit]s.
class SpeedUnits {
  static const units = [
    SimpleUnit(
      category: Category.speed,
      code: 'm-s',
      name: 'm/s',
      precision: 3,
      symbol: 'm/s',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.speed,
      code: 'mph',
      name: 'mph',
      precision: 3,
      symbol: 'mph',
      factor: '0.44704',
    ),
    SimpleUnit(
      category: Category.speed,
      code: 'km-h',
      name: 'km/h',
      precision: 3,
      symbol: 'km/h',
      factor: '0.277778',
    ),
  ];

  static final _baseUnit = fromCode('m-s');

  static SimpleUnit get baseUnit => _baseUnit;

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
