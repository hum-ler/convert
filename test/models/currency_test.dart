import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/currency.dart';
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

  test('Currency toJson', () {
    final currency = Currency(
      code: 'USD',
      symbol: r'$',
      name: 'United States Dollar',
      exchangeRate: '1.2345678',
      precision: 2,
      regionEmoji: '🇺🇸',
    );
    final json =
        r'{"code":"USD","symbol":"$","name":"United States Dollar","exchange-rate":"1.2345678","precision":2,"region-emoji":"🇺🇸"}';

    expect(Currency.toJson(currency), json);
  });

  test('Currency fromJson', () {
    final currency = Currency(
      code: 'USD',
      symbol: r'$',
      name: 'United States Dollar',
      exchangeRate: '1.2345678',
      precision: 2,
      regionEmoji: '🇺🇸',
    );
    final json =
        r'{"code":"USD","symbol":"$","name":"United States Dollar","exchange-rate":"1.2345678","precision":2,"region-emoji":"🇺🇸"}';

    final parsedCurrency = Currency.fromJson(json);
    expect(parsedCurrency, isNotNull);
    expect(parsedCurrency?.compareTo(currency), isZero);

    expect(parsedCurrency?.code, currency.code);
    expect(parsedCurrency?.symbol, currency.symbol);
    expect(parsedCurrency?.name, currency.name);
    expect(parsedCurrency?.exchangeRate, currency.exchangeRate);
    expect(parsedCurrency?.precision, currency.precision);
    expect(parsedCurrency?.regionEmoji, currency.regionEmoji);
  });
}
