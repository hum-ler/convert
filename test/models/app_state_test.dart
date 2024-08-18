import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('clearInputBuffer() is idempotent', () {
    final state = AppState();

    // Start with an empty input buffer.
    expect(state.inputBuffer, '');

    // clearInputBuffer() => still empty
    state.clearInput();
    expect(state.inputBuffer, '');

    // input 0 => 0
    state.pushInput(48);
    expect(state.inputBuffer, '0');

    // clearInputBuffer() => empty
    state.clearInput();
    expect(state.inputBuffer, '');

    // Repeat clearInputBuffer() => still empty
    state.clearInput();
    expect(state.inputBuffer, '');
  });

  test('Validate start-up input and output currencies', () {
    final state = AppState();

    state.category = Category.currency;

    expect(Category.currency.baseUnit, Category.currency.fromCode('SGD'));
    expect(state.inputUnit, Category.currency.fromCode('SGD'));
    expect(state.outputUnit, Category.currency.fromCode('SGD'));
  });

  test('Validate bookmarks', () {
    final state = AppState();

    state.category = Category.currency;

    final baseUnit = Category.currency.baseUnit;

    final aud = Category.currency.fromCode('AUD');
    final eur = Category.currency.fromCode('EUR');

    state.bookmark1 = (inputUnit: aud, outputUnit: eur);
    expect(state.bookmark1.inputUnit, aud);
    expect(state.bookmark1.outputUnit, eur);

    expect(state.bookmark2.inputUnit, baseUnit);
    expect(state.bookmark2.outputUnit, baseUnit);

    final usd = Category.currency.fromCode('USD');
    final myr = Category.currency.fromCode('MYR');
    state.bookmark2 = (inputUnit: usd, outputUnit: myr);
    expect(state.bookmark2.inputUnit, usd);
    expect(state.bookmark2.outputUnit, myr);
  });
}
