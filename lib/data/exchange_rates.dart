import 'package:convert_unit/models/currency.dart';

/// The collection of [Currency] information.
class ExchangeRates {
  static final _currencies = [
    Currency(
      code: 'AUD',
      symbol: r'$',
      name: 'Australian Dollar',
      exchangeRate: '1.1751',
      precision: 2,
      regionEmoji: '🇦🇺',
    ),
    Currency(
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
      exchangeRate: '0.6920',
      precision: 2,
      regionEmoji: '🇪🇺',
    ),
    Currency(
      code: 'GBP',
      symbol: '£',
      name: 'Pound sterling',
      exchangeRate: '0.5918',
      precision: 2,
      regionEmoji: '🇬🇧',
    ),
    Currency(
      code: 'JPY',
      symbol: '¥',
      name: 'Japanese Yen',
      exchangeRate: '107.7739',
      precision: 0,
      regionEmoji: '🇯🇵',
    ),
    Currency(
      code: 'MYR',
      symbol: 'RM',
      name: 'Malaysian Ringgit',
      exchangeRate: '3.3415',
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
      exchangeRate: '0.7551',
      precision: 2,
      regionEmoji: '🇺🇸',
    ),
  ];

  static List<Currency> get currencies => _currencies;

  static final _baseCurrency = fromCode('SGD');

  static Currency get baseCurrency => _baseCurrency;

  static final _lastUpdated = DateTime(2024, 8, 5);

  static DateTime get lastUpdated => _lastUpdated;

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

  /// Patches the Currency identified by [code] in [currencies], with
  /// the provided information.
  ///
  /// This is not thread-safe.
  static void patch(
    String code, {
    String? symbol,
    String? name,
    String? exchangeRate,
    int? precision,
    String? regionEmoji,
  }) {
    tryFromCode(code)?.patch(
      symbol: symbol,
      name: name,
      exchangeRate: exchangeRate,
      precision: precision,
      regionEmoji: regionEmoji,
    );
  }

  /// Retrieves and patches [currencies] with information from UpdateService.
  ///
  /// This is not thread-safe.
  static Future<void> update() async {
    // TODO: update exchange rates.
  }
}
