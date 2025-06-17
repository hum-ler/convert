import 'package:convert_unit/models/currency.dart';
import 'package:convert_unit/models/unit.dart';

/// The collection of [Currency] information.
class ExchangeRates {
  static final _currencies = [
    Currency(
      code: 'AUD',
      symbol: r'$',
      name: 'Australian Dollar',
      exchangeRate: '1.1665196',
      precision: 2,
      regionEmoji: '🇦🇺',
    ),
    Currency(
      code: 'CZK',
      symbol: r'Kč',
      name: 'Czech Koruna',
      exchangeRate: '17.655846',
      precision: 0,
      regionEmoji: '🇨🇿',
    ),
    Currency(
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
      exchangeRate: '0.70580126',
      precision: 2,
      regionEmoji: '🇪🇺',
    ),
    Currency(
      code: 'GBP',
      symbol: '£',
      name: 'Pound Sterling',
      exchangeRate: '0.58744582',
      precision: 2,
      regionEmoji: '🇬🇧',
    ),
    Currency(
      code: 'JPY',
      symbol: '¥',
      name: 'Japanese Yen',
      exchangeRate: '113.95138',
      precision: 0,
      regionEmoji: '🇯🇵',
    ),
    Currency(
      code: 'KRW',
      symbol: '₩',
      name: 'South Korean Won',
      exchangeRate: '1064.2057',
      precision: 0,
      regionEmoji: '🇰🇷',
    ),
    Currency(
      code: 'MYR',
      symbol: 'RM',
      name: 'Malaysian Ringgit',
      exchangeRate: '3.2991793',
      precision: 2,
      regionEmoji: '🇲🇾',
    ),
    Currency(
      code: 'SGD',
      symbol: r'$',
      name: 'Singapore Dollar',
      exchangeRate: '1.0',
      precision: 2,
      regionEmoji: '🇸🇬',
    ),
    Currency(
      code: 'USD',
      symbol: r'$',
      name: 'United States Dollar',
      exchangeRate: '0.74135876',
      precision: 2,
      regionEmoji: '🇺🇸',
    ),
  ];

  static List<Currency> get currencies => _currencies;

  static var _baseCurrency = fromCode('SGD');

  static Currency get baseCurrency => _baseCurrency;

  static UnitPair get defaultCurrencies =>
      (inputUnit: fromCode('USD'), outputUnit: _baseCurrency);

  /// The timestamp of the last currencies update.
  static var lastUpdated = DateTime(2024, 8, 5);

  /// Finds the Currency identified by [code] in [currencies].
  ///
  /// Throws StateError if [code] is not found.
  static Currency fromCode(String code) {
    return _currencies.firstWhere((currency) => currency.code == code);
  }

  /// Finds the Currency identified by [code] in [currencies].
  ///
  /// Return null if [code] is not found.
  static Currency? tryFromCode(String code) {
    try {
      return fromCode(code);
    } on StateError {
      return null;
    }
  }

  /// Finds the index (position) of the Currency identified by [code]
  /// in [currencies].
  ///
  /// Returns -1 if [code] is not found.
  static int toIndex(String code) {
    return _currencies.indexWhere((currency) => currency.code == code);
  }

  /// Finds the index (position) of the Currency identified by [code]
  /// in [currencies].
  ///
  /// Returns null if [code] is not found.
  static int? tryToIndex(String code) {
    final index = _currencies.indexWhere((currency) => currency.code == code);

    return index != -1 ? index : null;
  }

  /// Updates [currencies] with the given replacement. Also updates the
  /// [baseCurrency].
  ///
  /// The provided list must contain at least the Currency with
  /// [baseCurrencyCode]. If not found, the update will be aborted.
  static void updateCurrencies(
    List<Currency> currencies,
    String baseCurrencyCode,
  ) {
    currencies.sort((a, b) => a.code.compareTo(b.code));

    final Currency baseCurrency;
    try {
      baseCurrency = currencies
          .firstWhere((currency) => currency.code == baseCurrencyCode);
    } on StateError {
      return;
    }

    _currencies
      ..clear()
      ..addAll(currencies);

    _baseCurrency = baseCurrency;
  }
}
