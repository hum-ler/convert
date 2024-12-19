import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting app settings and state.
class PersistenceService {
  /// The SharedPreference for getting / setting values.
  ///
  /// Make sure to check for null before using.
  late SharedPreferences? _sharedPreferences;

  PersistenceService({SharedPreferences? sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  /// Initializes the [SharedPreferences].
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Clears any saved state.
  Future<void> clear() async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    await sharedPreferences.clear();
  }

  /// Retrieves the full saved state.
  ///
  /// If a key has not been stored previously, its value will keep the
  /// initialized value from AppState.
  AppState retrieveState() {
    final state = AppState();

    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return state;

    final colorSchemeSeed = retrieveColorSchemeSeed();
    if (colorSchemeSeed != null) state.colorSchemeSeed = colorSchemeSeed;

    final themeMode = retrieveThemeMode();
    if (themeMode != null) state.themeMode = themeMode;

    final category = retrieveCategory();
    if (category != null) state.category = category;

    final insertGroupSeparators = retrieveInsertGroupSeparators();
    if (insertGroupSeparators != null) {
      state.insertGroupSeparators = insertGroupSeparators;
    }

    for (final category in Category.values) {
      final units = retrieveUnits(category);
      if (units != null) {
        state.loadCategoryUnits(category, units);

        if (category == state.category) state.units = units;
      }

      final bookmark1 = retrieveBookmark(category, 1);
      if (bookmark1 != null) state.loadCategoryBookmark1(category, bookmark1);

      final bookmark2 = retrieveBookmark(category, 2);
      if (bookmark2 != null) state.loadCategoryBookmark2(category, bookmark2);
    }

    return state;
  }

  /// Retrieves the color scheme seed.
  Color? retrieveColorSchemeSeed() {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    final colorSchemeSeedA = sharedPreferences.getDouble('color-scheme-seed-a');
    final colorSchemeSeedR = sharedPreferences.getDouble('color-scheme-seed-r');
    final colorSchemeSeedG = sharedPreferences.getDouble('color-scheme-seed-g');
    final colorSchemeSeedB = sharedPreferences.getDouble('color-scheme-seed-b');

    if (colorSchemeSeedA != null &&
        colorSchemeSeedR != null &&
        colorSchemeSeedG != null &&
        colorSchemeSeedB != null) {
      return Color.from(
        alpha: colorSchemeSeedA,
        red: colorSchemeSeedR,
        green: colorSchemeSeedG,
        blue: colorSchemeSeedB,
      );
    }

    return null;
  }

  /// Stores the color scheme seed.
  Future<void> storeColorSchemeSeed(Color color) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    await sharedPreferences.setDouble('color-scheme-seed-a', color.a);
    await sharedPreferences.setDouble('color-scheme-seed-r', color.r);
    await sharedPreferences.setDouble('color-scheme-seed-g', color.g);
    await sharedPreferences.setDouble('color-scheme-seed-b', color.b);
  }

  /// Retrieve the theme mode.
  ThemeMode? retrieveThemeMode() {
    // FIXME: enum index may change.
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    final themeMode = sharedPreferences.getInt('theme-mode');
    if (themeMode != null) return ThemeMode.values[themeMode];

    return null;
  }

  /// Stores the theme mode.
  Future<void> storeThemeMode(ThemeMode mode) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    await sharedPreferences.setInt('theme-mode', mode.index);
  }

  /// Retrieves the current category.
  Category? retrieveCategory() {
    // FIXME: enum index may change.
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    final category = sharedPreferences.getInt('category');
    if (category != null) return Category.values[category];

    return null;
  }

  /// Stores the current category.
  Future<void> storeCategory(Category category) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    await sharedPreferences.setInt('category', category.index);
  }

  /// Retrieves the insert group separators option.
  bool? retrieveInsertGroupSeparators() {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    return sharedPreferences.getBool('insert-group-separators');
  }

  /// Stores the insert group separators option.
  Future<void> storeInsertGroupSeparators(bool shouldInsert) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    await sharedPreferences.setBool('insert-group-separators', shouldInsert);
  }

  /// Retrieves the current input / output unit pair.
  UnitPair? retrieveUnits(Category category) {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    final prefix = category.name;
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    final inputUnitCode = sharedPreferences.getString(inputUnitKey);
    if (inputUnitCode == null) return null;
    final outputUnitCode = sharedPreferences.getString(outputUnitKey);
    if (outputUnitCode == null) return null;

    final inputUnit = category.tryFromCode(inputUnitCode);
    if (inputUnit == null) return null;
    final outputUnit = category.tryFromCode(outputUnitCode);
    if (outputUnit == null) return null;

    return (inputUnit: inputUnit, outputUnit: outputUnit);
  }

  /// Stores the current input / output unit pair.
  Future<void> storeUnits(Category category, UnitPair units) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    final prefix = category.name;
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    await sharedPreferences.setString(inputUnitKey, units.inputUnit.code);
    await sharedPreferences.setString(outputUnitKey, units.outputUnit.code);
  }

  /// Retrieves the current bookmark.
  Bookmark? retrieveBookmark(Category category, int bookmarkNumber) {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return null;

    final prefix = 'bookmark-$bookmarkNumber-${category.name}';
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    final inputUnitCode = sharedPreferences.getString(inputUnitKey);
    if (inputUnitCode == null) return null;
    final outputUnitCode = sharedPreferences.getString(outputUnitKey);
    if (outputUnitCode == null) return null;

    final inputUnit = category.tryFromCode(inputUnitCode);
    if (inputUnit == null) return null;
    final outputUnit = category.tryFromCode(outputUnitCode);
    if (outputUnit == null) return null;

    return (inputUnit: inputUnit, outputUnit: outputUnit);
  }

  /// Retrieves the current bookmark.
  Future<void> storeBookmark(
    Category category,
    int bookmarkNumber,
    Bookmark bookmark,
  ) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) return;

    final prefix = 'bookmark-$bookmarkNumber-${category.name}';
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    await sharedPreferences.setString(inputUnitKey, bookmark.inputUnit.code);
    await sharedPreferences.setString(outputUnitKey, bookmark.outputUnit.code);
  }
}
