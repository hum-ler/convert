import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting app settings and state.
class PersistenceService {
  PersistenceService({SharedPreferencesAsync? sharedPreferences})
      : _sharedPreferences = sharedPreferences ?? SharedPreferencesAsync();

  /// The [SharedPreferenceAsync] for getting / setting values.
  final SharedPreferencesAsync _sharedPreferences;

  /// Clears any saved state.
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  /// Retrieves the full saved state.
  ///
  /// If a key has not been stored previously, its value will keep the
  /// initialized value from [AppState].
  Future<AppState> retrieveState() async {
    final state = AppState();

    final colorSchemeSeed = await retrieveColorSchemeSeed();
    if (colorSchemeSeed != null) state.colorSchemeSeed = colorSchemeSeed;

    final themeMode = await retrieveThemeMode();
    if (themeMode != null) state.themeMode = themeMode;

    final category = await retrieveCategory();
    if (category != null) state.category = category;

    final insertGroupSeparators = await retrieveInsertGroupSeparators();
    if (insertGroupSeparators != null) {
      state.insertGroupSeparators = insertGroupSeparators;
    }

    for (final category in Category.values) {
      final units = await retrieveUnits(category);
      if (units != null) {
        state.loadCategoryUnits(category, units);

        if (category == state.category) state.units = units;
      }

      final bookmark1 = await retrieveBookmark(category, 1);
      if (bookmark1 != null) state.loadCategoryBookmark1(category, bookmark1);

      final bookmark2 = await retrieveBookmark(category, 2);
      if (bookmark2 != null) state.loadCategoryBookmark2(category, bookmark2);
    }

    return state;
  }

  /// Retrieves the color scheme seed.
  Future<Color?> retrieveColorSchemeSeed() async {
    final colorSchemeSeedA =
        await _sharedPreferences.getDouble('color-scheme-seed-a');
    final colorSchemeSeedR =
        await _sharedPreferences.getDouble('color-scheme-seed-r');
    final colorSchemeSeedG =
        await _sharedPreferences.getDouble('color-scheme-seed-g');
    final colorSchemeSeedB =
        await _sharedPreferences.getDouble('color-scheme-seed-b');

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
    await _sharedPreferences.setDouble('color-scheme-seed-a', color.a);
    await _sharedPreferences.setDouble('color-scheme-seed-r', color.r);
    await _sharedPreferences.setDouble('color-scheme-seed-g', color.g);
    await _sharedPreferences.setDouble('color-scheme-seed-b', color.b);
  }

  /// Retrieve the theme mode.
  Future<ThemeMode?> retrieveThemeMode() async {
    final themeMode = await _sharedPreferences.getInt('theme-mode');
    if (themeMode != null) return ThemeMode.values[themeMode];

    return null;
  }

  /// Stores the theme mode.
  Future<void> storeThemeMode(ThemeMode mode) async {
    await _sharedPreferences.setInt('theme-mode', mode.index);
  }

  /// Retrieves the current category.
  Future<Category?> retrieveCategory() async {
    final category = await _sharedPreferences.getInt('category');
    if (category != null) return Category.values[category];

    return null;
  }

  /// Stores the current category.
  Future<void> storeCategory(Category category) async {
    await _sharedPreferences.setInt('category', category.index);
  }

  /// Retrieves the insert group separators option.
  Future<bool?> retrieveInsertGroupSeparators() async {
    return _sharedPreferences.getBool('insert-group-separators');
  }

  /// Stores the insert group separators option.
  Future<void> storeInsertGroupSeparators(bool shouldInsert) async {
    await _sharedPreferences.setBool('insert-group-separators', shouldInsert);
  }

  /// Retrieves the current input / output unit pair.
  Future<UnitPair?> retrieveUnits(Category category) async {
    final prefix = category.name;
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    final inputUnitCode = await _sharedPreferences.getString(inputUnitKey);
    if (inputUnitCode == null) return null;
    final outputUnitCode = await _sharedPreferences.getString(outputUnitKey);
    if (outputUnitCode == null) return null;

    final inputUnit = category.tryFromCode(inputUnitCode);
    if (inputUnit == null) return null;
    final outputUnit = category.tryFromCode(outputUnitCode);
    if (outputUnit == null) return null;

    return (inputUnit: inputUnit, outputUnit: outputUnit);
  }

  /// Stores the current input / output unit pair.
  Future<void> storeUnits(Category category, UnitPair units) async {
    final prefix = category.name;
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    await _sharedPreferences.setString(inputUnitKey, units.inputUnit.code);
    await _sharedPreferences.setString(outputUnitKey, units.outputUnit.code);
  }

  /// Retrieves the current bookmark.
  Future<Bookmark?> retrieveBookmark(
      Category category, int bookmarkNumber) async {
    final prefix = 'bookmark-$bookmarkNumber-${category.name}';
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    final inputUnitCode = await _sharedPreferences.getString(inputUnitKey);
    if (inputUnitCode == null) return null;
    final outputUnitCode = await _sharedPreferences.getString(outputUnitKey);
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
    final prefix = 'bookmark-$bookmarkNumber-${category.name}';
    final inputUnitKey = '$prefix-input-unit';
    final outputUnitKey = '$prefix-output-unit';

    await _sharedPreferences.setString(inputUnitKey, bookmark.inputUnit.code);
    await _sharedPreferences.setString(outputUnitKey, bookmark.outputUnit.code);
  }
}
