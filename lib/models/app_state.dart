import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:flutter/material.dart';

/// The application state.
class AppState extends ChangeNotifier {
  // TODO: set reasonable defaults for input and output units, instead of just
  // using base units for both.

  // colorSchemeSeed

  var _colorSchemeSeed = Colors.red as Color;

  Color get colorSchemeSeed => _colorSchemeSeed;

  set colorSchemeSeed(Color color) {
    _colorSchemeSeed = color;

    notifyListeners();
  }

  // themeMode

  var _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;

    notifyListeners();
  }

  // category

  var _category = Category.currency;

  Category get category => _category;

  set category(Category category) {
    _category = category;

    notifyListeners();
  }

  // currencySymbolPosition

  var _currencySymbolPosition = SymbolPosition.prefix;

  SymbolPosition get currencySymbolPosition => _currencySymbolPosition;

  set currencySymbolPosition(SymbolPosition position) {
    _currencySymbolPosition = position;

    notifyListeners();
  }

  // decimalSeparator

  var _decimalSeparator = '.';

  String get decimalSeparator => _decimalSeparator;

  set decimalSeparator(String separator) {
    _decimalSeparator = separator;

    notifyListeners();
  }

  // insertGroupSeparators

  var _insertGroupSeparators = false;

  bool get insertGroupSeparators => _insertGroupSeparators;

  set insertGroupSeparators(bool shouldInsert) {
    _insertGroupSeparators = shouldInsert;

    notifyListeners();
  }

  // groupSeparator

  var _groupSeparator = ',';

  String get groupSeparator => _groupSeparator;

  set groupSeparator(String separator) {
    _groupSeparator = separator;

    notifyListeners();
  }

  // integerGroupSize

  var _integerGroupSize = 3;

  int get integerGroupSize => _integerGroupSize;

  set integerGroupSize(int size) {
    assert(size >= 0);

    _integerGroupSize = size;

    notifyListeners();
  }

  // fractionGroupSize

  var _fractionGroupSize = 3;

  int get fractionGroupSize => _fractionGroupSize;

  set fractionGroupSize(int size) {
    assert(size >= 0);

    _fractionGroupSize = size;

    notifyListeners();
  }

  // inputBuffer

  // TODO: support negative input for temperature.

  final _inputBuffers = {
    for (final category in Category.values) category: <int>[]
  };

  String get inputBuffer => String.fromCharCodes(_inputBuffers[category]!);

  /// Loads [input] into the input buffer, discarding the existing content.
  void loadInput(String input) {
    final inputBuffer = _inputBuffers[category]!;

    inputBuffer.clear();
    inputBuffer.addAll(input.codeUnits);

    notifyListeners();
  }

  /// Pushes [input] to the back of the input buffer.
  void pushInput(int input) {
    _inputBuffers[category]!.add(input);

    notifyListeners();
  }

  /// Pops and discards the last input from the back of the input buffer.
  void popInput() {
    final inputBuffer = _inputBuffers[category]!;

    if (inputBuffer.isNotEmpty) {
      inputBuffer.removeLast();

      notifyListeners();
    }
  }

  /// Clears and discards the content of the input buffer.
  void clearInput() {
    final inputBuffer = _inputBuffers[category]!;

    if (inputBuffer.isNotEmpty) {
      inputBuffer.clear();

      notifyListeners();
    }
  }

  // inputUnits

  final _inputUnits = {
    for (final category in Category.values) category: category.baseUnit
  };

  Unit get inputUnit => _inputUnits[category]!;

  set inputUnit(Unit unit) {
    _inputUnits[category] = unit;

    notifyListeners();
  }

  // outputUnits

  final _outputUnits = {
    for (final category in Category.values) category: category.baseUnit
  };

  Unit get outputUnit => _outputUnits[category]!;

  set outputUnit(Unit unit) {
    _outputUnits[category] = unit;

    notifyListeners();
  }

  // units

  UnitPair get units {
    return (
      inputUnit: _inputUnits[category]!,
      outputUnit: _outputUnits[category]!,
    );
  }

  set units(UnitPair units) {
    _inputUnits[category] = units.inputUnit;
    _outputUnits[category] = units.outputUnit;

    notifyListeners();
  }

  void loadCategoryUnits(Category category, UnitPair units) {
    _inputUnits[category] = units.inputUnit;
    _outputUnits[category] = units.outputUnit;
  }

  // bookmark1

  final _bookmark1s = {
    for (final category in Category.values)
      category: (inputUnit: category.baseUnit, outputUnit: category.baseUnit)
  };

  Bookmark get bookmark1 => _bookmark1s[category]!;

  set bookmark1(Bookmark bookmark) {
    _bookmark1s[category] = bookmark;

    notifyListeners();
  }

  void loadCategoryBookmark1(Category category, Bookmark bookmark) {
    _bookmark1s[category] = bookmark;
  }

  // bookmark2

  final _bookmark2s = {
    for (final category in Category.values)
      category: (inputUnit: category.baseUnit, outputUnit: category.baseUnit)
  };

  Bookmark get bookmark2 => _bookmark2s[category]!;

  set bookmark2(Bookmark bookmark) {
    _bookmark2s[category] = bookmark;

    notifyListeners();
  }

  void loadCategoryBookmark2(Category category, Bookmark bookmark) {
    _bookmark2s[category] = bookmark;
  }
}
