import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Unit>()])
import 'utility_test.mocks.dart';

void main() {
  test('Check convertUnit() with rounding', () {
    final unit1 = MockUnit();
    final unit2 = MockUnit();

    when(unit1.category).thenReturn(Category.weight);
    when(unit1.toBaseUnit).thenReturn((input) {
      return input * Decimal.parse('3.2865');
    });
    when(unit1.fromBaseUnit).thenReturn((input) {
      return input * Decimal.parse('3.2865');
    });

    when(unit2.category).thenReturn(Category.weight);
    when(unit2.toBaseUnit).thenReturn((input) {
      return input * Decimal.parse('0.6204');
    });
    when(unit2.fromBaseUnit).thenReturn((input) {
      return input * Decimal.parse('0.6204');
    });

    expect(
      printRoundedDecimal(
        convertUnit(
          Decimal.parse('1.1141'),
          unit1,
          unit2,
        ),
      ),
      '2.27',
    );

    expect(
      printRoundedDecimal(
        convertUnit(
          Decimal.parse('1.1141'),
          unit2,
          unit1,
        ),
      ),
      '2.27',
    );

    expect(
      printRoundedDecimal(
        convertUnit(
          Decimal.parse('0'),
          unit1,
          unit2,
        ),
      ),
      '0',
    );

    expect(
      printRoundedDecimal(
        convertUnit(
          Decimal.parse('0.0000'),
          unit2,
          unit1,
        ),
      ),
      '0',
    );
  });

  test('Validate inserting group separators', () {
    expect(
      insertIntegerGroupSeparators('1234567890', ','),
      '1,234,567,890',
    );

    expect(insertIntegerGroupSeparators('1234', ','), '1,234');

    expect(insertIntegerGroupSeparators('123', ','), '123');

    expect(insertIntegerGroupSeparators('12', ','), '12');

    expect(insertIntegerGroupSeparators('', ','), '');

    expect(
      insertFractionGroupSeparators('1234567890', ','),
      '123,456,789,0',
    );

    expect(insertFractionGroupSeparators('1234', ','), '123,4');

    expect(insertFractionGroupSeparators('123', ','), '123');

    expect(insertIntegerGroupSeparators('12', ','), '12');

    expect(insertFractionGroupSeparators('', ','), '');
  });
}
