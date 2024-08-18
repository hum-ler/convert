import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Currency comparison', () {
    final sgd = Currency(
      code: 'SGD',
      symbol: '',
      name: '',
      exchangeRate: '',
      precision: 0,
      regionEmoji: '',
    );
    final usd = Currency(
      code: 'USD',
      symbol: '',
      name: '',
      exchangeRate: '',
      precision: 0,
      regionEmoji: '',
    );
    expect(sgd.compareTo(usd), isNegative);
    expect(usd.compareTo(sgd), isPositive);
    expect(sgd.compareTo(sgd), isZero);

    final sgd2 = Category.currency.fromCode('SGD') as Currency;
    expect(sgd.compareTo(sgd2), isZero);
  });

  test('Currency sorting', () {
    final myr = Currency(
      code: 'MYR',
      symbol: '',
      name: '',
      exchangeRate: '',
      precision: 0,
      regionEmoji: '',
    );
    final sgd = Currency(
      code: 'SGD',
      symbol: '',
      name: '',
      exchangeRate: '',
      precision: 0,
      regionEmoji: '',
    );
    final usd = Currency(
      code: 'USD',
      symbol: '',
      name: '',
      exchangeRate: '',
      precision: 0,
      regionEmoji: '',
    );

    final sorted = [usd, sgd, myr];
    sorted.sort((a, b) => a.compareTo(b));
    expect(sorted[0], myr);
    expect(sorted[1], sgd);
    expect(sorted[2], usd);
  });

  test('Currency patching', () {
    final c = Currency(
      code: 'C',
      symbol: '',
      name: '',
      exchangeRate: '1',
      precision: 0,
      regionEmoji: '',
    );

    expect(c.code, 'C');
    expect(c.symbol, isEmpty);
    expect(c.name, isEmpty);
    expect(c.exchangeRate, Decimal.fromInt(1));
    expect(c.precision, isZero);
    expect(c.regionEmoji, isEmpty);

    c.patch(
      symbol: r'$',
      name: 'check',
      exchangeRate: '2.3',
      precision: 2,
      regionEmoji: '🌏',
    );
    expect(c.code, 'C');
    expect(c.symbol, r'$');
    expect(c.name, 'check');
    expect(c.exchangeRate, Decimal.parse('2.3'));
    expect(c.precision, 2);
    expect(c.regionEmoji, '🌏');

    c.patch(exchangeRate: 'check');
    expect(c.exchangeRate, Decimal.parse('2.3'));
  });
}
