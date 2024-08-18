import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/simple_unit.dart';

/// The collection of length [SimpleUnit]s.
class LengthUnits {
  static const units = [
    SimpleUnit(
      category: Category.length,
      code: 'mi',
      name: 'mile',
      precision: 6,
      symbol: 'mi',
      factor: '1609.344',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'km',
      name: 'kilometre',
      precision: 6,
      symbol: 'km',
      factor: '1000',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'm',
      name: 'metre',
      precision: 3,
      symbol: 'm',
      factor: '1',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'yd',
      name: 'yard',
      precision: 3,
      symbol: 'yd',
      factor: '0.9144',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'ft',
      name: 'foot',
      precision: 2,
      symbol: 'ft',
      factor: '0.3048',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'in',
      name: 'inch',
      precision: 1,
      symbol: 'in',
      factor: '0.0254',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'cm',
      name: 'centimetre',
      precision: 1,
      symbol: 'cm',
      factor: '0.01',
    ),
    SimpleUnit(
      category: Category.length,
      code: 'mm',
      name: 'millimetre',
      precision: 0,
      symbol: 'mm',
      factor: '0.001',
    ),
  ];

  static final _baseUnit = fromCode('m');

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
