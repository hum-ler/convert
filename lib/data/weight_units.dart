import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';

/// The collection of mass [SimpleUnit]s.
class WeightUnits {
  static const units = [
    SimpleUnit(
      category: Category.weight,
      code: 'uk-t',
      name: 'UK ton',
      precision: 6,
      symbol: 'ton',
      factor: '1016',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 't',
      name: 'tonne',
      precision: 6,
      symbol: 't',
      factor: '1000',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'us-t',
      name: 'US ton',
      precision: 6,
      symbol: 'ton',
      factor: '907.18',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'st',
      name: 'stone',
      precision: 3,
      symbol: 'st',
      factor: '6.35029318',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'kg',
      name: 'kilogram',
      precision: 3,
      symbol: 'kg',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'lb',
      name: 'pound',
      precision: 2,
      symbol: 'lb',
      factor: '0.45359237',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'oz',
      name: 'ounce',
      precision: 1,
      symbol: 'oz',
      factor: '0.028349523125',
    ),
    SimpleUnit(
      category: Category.weight,
      code: 'g',
      name: 'gram',
      precision: 0,
      symbol: 'g',
      factor: '0.001',
    ),
  ];

  static final _baseUnit = fromCode('kg');

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
