import 'package:convert_unit/models/category.dart';
import 'package:decimal/decimal.dart';

/// A [Unit] that can do value conversions to another [Unit] under the same
/// [Category].
///
/// This is used in conjunction with convertUnit() under utilities.
abstract class Unit {
  /// The ID code of this [Unit].
  ///
  /// [code] must be unique between [Unit]s under the same [Category].
  String get code;

  /// The [Category] that this [Unit] falls under.
  ///
  /// [Unit]s under the same [Category] can convert values between them.
  Category get category;

  /// The name of this [Unit].
  String get name;

  /// The symbol of this [Unit].
  String get symbol;

  /// The number of decimal places to preserve.
  ///
  /// If the number of decimal places exceeds [precision], normal rounding
  /// should be applied.
  int get precision;

  /// Gets a function that converts a value in this [Unit] to the base unit in
  /// the [category].
  Decimal Function(Decimal) get toBaseUnit;

  /// Gets a function that converts a value from the [category]'s base unit to
  /// this [Unit].
  Decimal Function(Decimal) get fromBaseUnit;
}

typedef UnitPair = ({Unit inputUnit, Unit outputUnit});

typedef Bookmark = UnitPair;
