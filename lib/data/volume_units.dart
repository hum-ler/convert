import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';
import 'package:convert_unit/models/unit.dart';

/// The collection of volume [SimpleUnit]s.
class VolumeUnits {
  static const units = [
    SimpleUnit(
      category: Category.volume,
      code: 'm3',
      name: 'cubic metre',
      precision: 6,
      symbol: 'm³',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'ft3',
      name: 'cubic foot',
      precision: 4,
      symbol: 'ft³',
      factor: '0.028316846592',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'uk-gal',
      name: 'UK gallon',
      precision: 3,
      symbol: 'gal',
      factor: '0.00454609',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'us-gal',
      name: 'US gallon',
      precision: 3,
      symbol: 'gal',
      factor: '0.003785411784',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'l',
      name: 'litre',
      precision: 3,
      symbol: 'L',
      factor: '0.001',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'qt',
      name: 'quart',
      precision: 3,
      symbol: 'qt',
      factor: '0.000946352946',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'cup',
      name: 'cup',
      precision: 2,
      symbol: 'cup',
      factor: '0.0002365882365',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'fl-oz',
      name: 'ounce',
      precision: 1,
      symbol: 'fl oz',
      factor: '0.0000295735295625',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'in3',
      name: 'cubic inch',
      precision: 1,
      symbol: 'in³',
      factor: '0.000016387064',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'tbsp',
      name: 'tablespoon',
      precision: 0,
      symbol: 'tbsp',
      factor: '0.00001478676478125',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'tsp',
      name: 'teaspoon',
      precision: 0,
      symbol: 'tsp',
      factor: '0.00000492892159375',
    ),
    SimpleUnit(
      category: Category.volume,
      code: 'ml',
      name: 'millilitre',
      precision: 0,
      symbol: 'ml',
      factor: '0.000001',
    ),
  ];

  static final _baseUnit = fromCode('m3');

  static SimpleUnit get baseUnit => _baseUnit;

  static UnitPair get defaultUnits =>
      (inputUnit: fromCode('fl-oz'), outputUnit: fromCode('l'));

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
