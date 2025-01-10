import 'package:convert_unit/models/temperature.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:decimal/decimal.dart';

/// The collection of [Temperature] units.
class TemperatureUnits {
  static final units = [
    Temperature(
      code: 'c',
      name: 'Celsius',
      symbol: 'ºC',
      toBaseUnit: (input) => input,
      fromBaseUnit: (input) => input,
    ),
    Temperature(
      code: 'f',
      name: 'Fahrenheit',
      symbol: 'ºF',
      toBaseUnit: (input) {
        return ((input - Decimal.fromInt(32)) *
                Decimal.fromInt(5) /
                Decimal.fromInt(9))
            .toDecimal(scaleOnInfinitePrecision: 15);
      },
      fromBaseUnit: (input) {
        return (input * Decimal.fromInt(9) / Decimal.fromInt(5))
                .toDecimal(scaleOnInfinitePrecision: 15) +
            Decimal.fromInt(32);
      },
    ),
  ];

  static Temperature get baseUnit => units.first;

  static UnitPair get defaultUnits =>
      (inputUnit: units.last, outputUnit: units.first);

  static Temperature fromCode(String code) {
    return units.firstWhere((unit) => unit.code == code);
  }

  static Temperature? tryFromCode(String code) {
    try {
      return fromCode(code);
    } on StateError {
      return null;
    }
  }
}
