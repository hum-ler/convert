import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';

/// The collection of area [SimpleUnit]s.
class AreaUnits {
  static const units = [
    SimpleUnit(
      category: Category.area,
      code: 'mi2',
      name: 'sq. mile',
      precision: 6,
      symbol: 'mi²',
      factor: '2589988.110336',
    ),
    SimpleUnit(
      category: Category.area,
      code: 'km2',
      name: 'sq. kilometre',
      precision: 6,
      symbol: 'km²',
      factor: '1000000',
    ),
    SimpleUnit(
      category: Category.area,
      code: 'hectare',
      name: 'hectare',
      precision: 6,
      symbol: 'ha',
      factor: '10000',
    ),
    SimpleUnit(
      category: Category.area,
      code: 'acre',
      name: 'acre',
      precision: 6,
      symbol: 'ac',
      factor: '4046.8564224',
    ),
    SimpleUnit(
      category: Category.area,
      code: 'm2',
      name: 'sq. metre',
      precision: 3,
      symbol: 'm²',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.area,
      code: 'ft2',
      name: 'sq. foot',
      precision: 1,
      symbol: 'ft²',
      factor: '0.09290304',
    ),
  ];

  static final _baseUnit = fromCode('m2');

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
