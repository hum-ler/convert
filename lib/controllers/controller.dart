import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:convert_unit/services/exchange_rates_update_service.dart';
import 'package:convert_unit/services/persistence_service.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:convert_unit/widgets/settings_page.dart';
import 'package:convert_unit/widgets/sign_in_page.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// The controller that mutates [AppState].
class Controller {
  /// The maximum number of [int] that can be stored in the input buffer.
  static const _inputBufferSize = 12;

  /// The [int] representation of period character (.).
  static const _codeUnitPeriod = 46;

  /// The [int] representation of zero character (0).
  ///
  /// The int values of other digits can be derived by adding the digit to the
  /// base 0 value. E.g. the code unit of 8 is 48 + 8.
  static const _codeUnitZero = 48;

  Controller({
    required AppState state,
    required PersistenceService persistenceService,
    required ExchangeRatesUpdateService exchangeRatesUpdateService,
  })  : _state = state,
        _persistenceService = persistenceService,
        _exchangeRatesUpdateService = exchangeRatesUpdateService;

  final AppState _state;

  final PersistenceService _persistenceService;

  final ExchangeRatesUpdateService _exchangeRatesUpdateService;

  void setCategory(Category? category) {
    if (category != null) {
      _persistenceService.storeCategory(category);

      _state.category = category;
    }
  }

  void setInputUnit(Unit? unit) {
    if (unit != null) {
      final units = (
        inputUnit: unit,
        outputUnit: _state.outputUnit,
      );

      _persistenceService.storeUnits(_state.category, units);

      _state.inputUnit = unit;
    }
  }

  void setOutputUnit(Unit? unit) {
    if (unit != null) {
      final units = (
        inputUnit: _state.inputUnit,
        outputUnit: unit,
      );

      _persistenceService.storeUnits(_state.category, units);

      _state.outputUnit = unit;
    }
  }

  void swapUnits() {
    final (:inputUnit, :outputUnit) = _state.units;

    final units = (
      inputUnit: outputUnit,
      outputUnit: inputUnit,
    );

    _persistenceService.storeUnits(_state.category, units);

    _state.units = units;
  }

  void clearInput() => _state.clearInput();

  void loadBookmark1() {
    _persistenceService.storeUnits(_state.category, _state.bookmark1);

    _state.units = _state.bookmark1;
  }

  void saveBookmark1() {
    _persistenceService.storeBookmark(_state.category, 1, _state.units);

    _state.bookmark1 = _state.units;
  }

  void loadBookmark2() {
    _persistenceService.storeUnits(_state.category, _state.bookmark2);

    _state.units = _state.bookmark2;
  }

  void saveBookmark2() {
    _persistenceService.storeBookmark(_state.category, 2, _state.units);

    _state.bookmark2 = _state.units;
  }

  Future<void> _copyToClipboard(String data) {
    return Clipboard.setData(ClipboardData(text: data));
  }

  Future<void> copyInputExportToClipboard() {
    return _copyToClipboard(exportInput(_state.inputBuffer));
  }

  Future<void> copyOutputExportToClipboard() {
    return _copyToClipboard(
      exportOutput(
        _state.inputBuffer,
        inputUnit: _state.inputUnit,
        outputUnit: _state.outputUnit,
        roundDecimalPlaces: _state.outputUnit.precision,
      ),
    );
  }

  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data == null) return;

    final text = data.text;
    if (text == null) return;

    final value = Decimal.tryParse(text);
    if (value == null) return;

    final roundedValue = printRoundedDecimal(
      value,
      roundDecimalPlaces: value.precision,
    );
    if (roundedValue.length > _inputBufferSize) return;

    _state.loadInput(roundedValue);
  }

  void _multiplyInput(Decimal factor) {
    assert(factor > Decimal.zero);

    final inputExport = exportInput(_state.inputBuffer);
    if (inputExport.isEmpty) return;

    final value = Decimal.parse(inputExport) * factor;
    final roundedValue = printRoundedDecimal(
      value,
      roundDecimalPlaces: value.precision,
    );
    if (roundedValue.length > _inputBufferSize) return;

    _state.loadInput(roundedValue);
  }

  void add10Percent() => _multiplyInput(Decimal.parse('1.1'));

  void add20Percent() => _multiplyInput(Decimal.parse('1.2'));

  void inputPeriod() {
    final inputBuffer = _state.inputBuffer;
    if (inputBuffer.length >= _inputBufferSize) return;

    final inputDisplay = displayInput(inputBuffer);

    if (inputDisplay.isEmpty) {
      _state.loadInput('0.');
    } else if (!inputDisplay.contains('.')) {
      _state.pushInput(_codeUnitPeriod);
    }
  }

  void _input(int rawValue) {
    final inputBuffer = _state.inputBuffer;
    if (inputBuffer.length >= _inputBufferSize) return;

    final inputDisplay = displayInput(inputBuffer);

    // Replace the first digit if it is '0'.
    if (inputDisplay == '0') {
      _state.loadInput(String.fromCharCode(rawValue + _codeUnitZero));
    } else {
      // Normal insertion.
      _state.pushInput(rawValue + _codeUnitZero);
    }
  }

  void input0() => _input(0);

  void input1() => _input(1);

  void input2() => _input(2);

  void input3() => _input(3);

  void input4() => _input(4);

  void input5() => _input(5);

  void input6() => _input(6);

  void input7() => _input(7);

  void input8() => _input(8);

  void input9() => _input(9);

  void deleteLastInput() => _state.popInput();

  void setColorSchemeSeed(Color color) {
    _persistenceService.storeColorSchemeSeed(color);

    _state.colorSchemeSeed = color;
  }

  void setThemeMode(ThemeMode mode) {
    _persistenceService.storeThemeMode(mode);

    _state.themeMode = mode;
  }

  void setInsertGroupSeparators(bool shouldInsert) {
    _persistenceService.storeInsertGroupSeparators(shouldInsert);

    _state.insertGroupSeparators = shouldInsert;
  }

  Future<void> updateExchangeRates(BuildContext? context) async {
    // If no temporary credentials, or if expired, make the user sign in.
    if (await _exchangeRatesUpdateService.requiresLogin()) {
      if (context != null && context.mounted) {
        _openSignInPage(context);
      }

      return;
    }

    // Update currencies using ExchangeRatesUpdateService.
    await _exchangeRatesUpdateService.updateCurrencies();

    // Persist currencies using PersistenceService.
    await _persistenceService.storeCurrencies(ExchangeRates.currencies);
    await _persistenceService
        .storeCurrenciesLastUpdated(ExchangeRates.lastUpdated);

    // Propagate changes.
    _state.currenciesLastUpdated = ExchangeRates.lastUpdated;
  }

  void openSettingsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider.value(value: context.read<Controller>()),
            ChangeNotifierProvider.value(
              value: context.read<AppState>(),
            ),
          ],
          child: const SettingsPage(),
        ),
      ),
    );
  }

  void _openSignInPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider.value(value: context.read<Controller>()),
            ChangeNotifierProvider.value(
              value: context.read<AppState>(),
            ),
          ],
          child: SignInPage(signInUrl: _exchangeRatesUpdateService.signInUrl),
        ),
      ),
    );
  }

  Future<void> updateServiceLogin(BuildContext context, String code) async {
    await _exchangeRatesUpdateService.login(code);

    updateExchangeRates(null);
  }

  Future<void> updateServiceLogout() => _exchangeRatesUpdateService.logout();
}
