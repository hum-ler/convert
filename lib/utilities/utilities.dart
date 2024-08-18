import 'package:convert_unit/models/unit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

/// Calculates the value in output unit from another input unit.
///
/// This method uses the base unit as an intermediate conversion i.e. the input
/// value is converted from its original unit to base unit first, and thereafter
/// converted to the desired output unit.
///
/// Every conversion *must* output a positive value! There is no checking.
Decimal convertUnit(
  Decimal value,
  Unit from,
  Unit to,
) {
  assert(value >= Decimal.zero);
  assert(from.category == to.category);

  return (to.fromBaseUnit(from.toBaseUnit(value)));
}

/// Prints a Decimal with appropriate rounding.
///
/// General behavior:
/// 1. Print integers without the decimal point.
/// 2. Round rational numbers to 2 decimal places.
/// 3. Remove all trailing zeroes in rational numbers.
String printRoundedDecimal(
  Decimal value, {
  int roundDecimalPlaces = 2,
  bool removeTrailingZeroes = true,
}) {
  assert(roundDecimalPlaces >= 0);

  // Check for whole number.
  if (value.isInteger || roundDecimalPlaces == 0) {
    return value.toStringAsFixed(0);
  }

  var rounded = value.toStringAsFixed(roundDecimalPlaces);

  // Chop off trailing zeros and period, if necessary.
  if (removeTrailingZeroes) {
    rounded = rounded.split(RegExp(r'0+$')).first;

    if (rounded.endsWith('.')) {
      rounded = rounded.substring(0, rounded.length - 1);
    }
  }

  return rounded;
}

/// Updates a whole or decimal number with the appropriate decimal and group
/// separators.
///
/// The input value should contain:
/// 1. Digits
/// 2. Zero or one period (.) as the decimal separator
/// 3. No group separators
String updateSeparators(
  String value, {
  String decimalSeparator = '.',
  String groupSeparator = ' ',
  int integerGroupSize = 3,
  int fractionGroupSize = 3,
  bool insertGroupSeparators = false,
}) {
  if (value.isEmpty) return '';

  assert(integerGroupSize > 1);
  assert(fractionGroupSize > 1);
  assert(value.indexOf('.') == value.lastIndexOf('.'));
  assert(!value.contains(','));

  var substituted = value.replaceFirst('.', decimalSeparator);

  if (insertGroupSeparators) {
    final parts = substituted.split(decimalSeparator);
    parts.first = insertIntegerGroupSeparators(
      parts.first,
      groupSeparator,
      groupSize: integerGroupSize,
    );
    if (parts.length > 1) {
      parts.last = insertFractionGroupSeparators(
        parts.last,
        groupSeparator,
        groupSize: fractionGroupSize,
      );
    }
    substituted = parts.join(decimalSeparator);
  }

  return substituted;
}

/// Inserts group separators into an integer String.
///
/// E.g. if each group is 3 digits: '1000000' => '1,000,000'.
String insertIntegerGroupSeparators(
  String value,
  String groupSeparator, {
  int groupSize = 3,
}) {
  assert(groupSize > 1);

  final length = value.length;
  if (length <= groupSize) return value;

  final chars = value.split('');
  for (var i = groupSize; i < length; i += groupSize) {
    chars.insert(length - i, groupSeparator);
  }

  return chars.join();
}

/// Inserts group separators into a fraction String.
///
/// E.g. if each group is 3 digits: '0000001' => '000,000,1'.
String insertFractionGroupSeparators(
  String value,
  String groupSeparator, {
  int groupSize = 3,
}) {
  assert(groupSize > 1);

  if (value.length <= groupSize) return value;

  final indexes = <int>[];
  for (var i = groupSize; i < value.length; i += groupSize) {
    indexes.add(i);
  }

  final chars = value.split('');
  for (final i in indexes.reversed) {
    chars.insert(i, groupSeparator);
  }

  return chars.join();
}

/// Formats an input buffer for display.
String displayInput(
  String inputBuffer, {
  String decimalSeparator = '.',
  bool insertGroupSeparators = false,
  String groupSeparator = ',',
  int integerGroupSize = 3,
  int fractionGroupSize = 3,
}) {
  return updateSeparators(
    inputBuffer,
    decimalSeparator: decimalSeparator,
    insertGroupSeparators: insertGroupSeparators,
    groupSeparator: groupSeparator,
    integerGroupSize: integerGroupSize,
    fractionGroupSize: fractionGroupSize,
  );
}

/// Formats an input buffer for exporting.
///
/// Used, for example, when copying to clipboard.
String exportInput(String inputBuffer) => inputBuffer;

/// Converts an input buffer to output value and formats for display.
String displayOutput(
  String inputBuffer, {
  required Unit inputUnit,
  required Unit outputUnit,
  int roundDecimalPlaces = 6,
  String decimalSeparator = '.',
  bool insertGroupSeparator = false,
  String groupSeparator = ',',
  int integerGroupSize = 3,
  int fractionGroupSize = 3,
}) {
  if (inputBuffer.isEmpty) return inputBuffer;

  return updateSeparators(
    printRoundedDecimal(
      convertUnit(Decimal.parse(inputBuffer), inputUnit, outputUnit),
      roundDecimalPlaces: roundDecimalPlaces,
    ),
    decimalSeparator: decimalSeparator,
    insertGroupSeparators: insertGroupSeparator,
    groupSeparator: groupSeparator,
    integerGroupSize: integerGroupSize,
    fractionGroupSize: fractionGroupSize,
  );
}

/// Converts an input buffer to output value and formats for exporting.
///
/// Used, for example, when copying to clipboard.
String exportOutput(
  String inputBuffer, {
  required Unit inputUnit,
  required Unit outputUnit,
  int roundDecimalPlaces = 6,
}) {
  if (inputBuffer.isEmpty) return inputBuffer;

  return printRoundedDecimal(
    convertUnit(Decimal.parse(inputBuffer), inputUnit, outputUnit),
    roundDecimalPlaces: roundDecimalPlaces,
  );
}

/// Displays a message in the snack bar.
///
/// A Scaffold must be found within the context.
void showSnackBarMessage(BuildContext context, String message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
