import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/services/persistence_service.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<PersistenceService>()])
import 'controller_test.mocks.dart';

void main() {
  test('C is idempotent', () {
    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    // Start with an empty display.
    expect(displayInput(state.inputBuffer), '');

    // Press C => still empty
    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');

    // Press 0 => 0
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    // Press C => empty
    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');

    // Repeat C => still empty
    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');
  });

  test('0 in the integer position will be replaced by N', () {
    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    // Start with an empty display.
    expect(displayInput(state.inputBuffer), '');

    // Press 0 => 0
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    // Repeat 0 => still 0
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    // Press some other number N => N
    controller.input2();
    expect(displayInput(state.inputBuffer), '2');
  });

  test('Entering period when empty will automatically insert 0 in front', () {
    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    // Start with an empty display.
    expect(displayInput(state.inputBuffer), '');

    // Press . once => 0.
    controller.inputPeriod();
    expect(displayInput(state.inputBuffer), '0.');

    // Repeat . => still 0.
    controller.inputPeriod();
    expect(displayInput(state.inputBuffer), '0.');

    // Press 0 => 0.0
    controller.input0();
    expect(displayInput(state.inputBuffer), '0.0');

    // Check that entering a period after 0 behaves normally.

    // Restart with an empty display.
    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');

    // Press 0 => 0
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    // Press . => 0.
    controller.inputPeriod();
    expect(displayInput(state.inputBuffer), '0.');

    // Repeat . => still 0.
    controller.inputPeriod();
    expect(displayInput(state.inputBuffer), '0.');
  });

  test("Validate adding 10 percent", () {
    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    // 110% of 0 is 0.
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    controller.add10Percent();
    expect(displayInput(state.inputBuffer), '0');

    // 110% of 1 is 1.1
    controller.clearInput();
    controller.input1();
    expect(displayInput(state.inputBuffer), '1');

    controller.add10Percent();
    expect(displayInput(state.inputBuffer), '1.1');
  });

  test("Validate adding 20 percent", () {
    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    // 120% of 0 is 0.
    controller.input0();
    expect(displayInput(state.inputBuffer), '0');

    controller.add20Percent();
    expect(displayInput(state.inputBuffer), '0');

    // 120% of 1 is 1.2
    controller.clearInput();
    controller.input1();
    expect(displayInput(state.inputBuffer), '1');

    controller.add20Percent();
    expect(displayInput(state.inputBuffer), '1.2');
  });

  test('Check setInputCurrency()', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    state.category = Category.currency;

    expect(state.inputUnit, Category.currency.baseUnit);

    final aud = Category.currency.fromCode('AUD');
    controller.setInputUnit(aud);
    expect(state.inputUnit, aud);
    verify(
      persistenceService.storeUnits(
        Category.currency,
        (inputUnit: aud, outputUnit: Category.currency.baseUnit),
      ),
    );
  });

  test('Check setOutputCurrency()', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    state.category = Category.currency;

    expect(state.outputUnit, Category.currency.baseUnit);

    final eur = Category.currency.fromCode('EUR');
    controller.setOutputUnit(eur);
    expect(state.outputUnit, eur);
    verify(
      persistenceService.storeUnits(
        Category.currency,
        (inputUnit: Category.currency.baseUnit, outputUnit: eur),
      ),
    );
  });

  test('Validate bookmarking', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    state.category = Category.currency;

    expect(state.bookmark1.inputUnit, Category.currency.baseUnit);
    expect(state.bookmark1.outputUnit, Category.currency.baseUnit);

    final aud = Category.currency.fromCode('AUD');
    final eur = Category.currency.fromCode('EUR');
    controller.setInputUnit(aud);
    controller.setOutputUnit(eur);
    controller.saveBookmark1();
    expect(state.bookmark1.inputUnit, aud);
    expect(state.bookmark1.outputUnit, eur);
    verify(
      persistenceService.storeBookmark(
        Category.currency,
        1,
        (inputUnit: aud, outputUnit: eur),
      ),
    );

    expect(state.bookmark2.inputUnit, Category.currency.baseUnit);
    expect(state.bookmark2.outputUnit, Category.currency.baseUnit);

    final usd = Category.currency.fromCode('USD');
    final myr = Category.currency.fromCode('MYR');
    controller.setInputUnit(usd);
    controller.setOutputUnit(myr);
    controller.saveBookmark2();
    expect(state.bookmark2.inputUnit, usd);
    expect(state.bookmark2.outputUnit, myr);
    verify(
      persistenceService.storeBookmark(
        Category.currency,
        2,
        (inputUnit: usd, outputUnit: myr),
      ),
    );
  });

  test('Validate currency swapping', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    expect(state.inputUnit, Category.currency.baseUnit);
    expect(state.outputUnit, Category.currency.baseUnit);

    final usd = Category.currency.fromCode('USD');
    final myr = Category.currency.fromCode('MYR');
    controller.setInputUnit(usd);
    controller.setOutputUnit(myr);
    expect(state.inputUnit, usd);
    expect(state.outputUnit, myr);

    controller.swapUnits();
    expect(state.inputUnit, myr);
    expect(state.outputUnit, usd);
    verify(
      persistenceService.storeUnits(
        Category.currency,
        (inputUnit: myr, outputUnit: usd),
      ),
    );
  });

  test("Validate copying & pasting", () async {
    // Mock the clipboard.
    // See https://docs.flutter.dev/testing/plugins-in-tests#mock-the-platform-channel.
    // See https://github.com/flutter/flutter/blob/main/packages/flutter/lib/src/services/clipboard.dart.
    var clipboardData = <String, dynamic>{};
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (methodCall) {
        if (methodCall.method == 'Clipboard.setData') {
          clipboardData = methodCall.arguments;
          return Future.value(methodCall.arguments);
        }

        if (methodCall.method == 'Clipboard.getData') {
          return Future.value(clipboardData);
        }

        return null;
      },
    );

    final state = AppState();
    final controller = Controller(
      state: state,
      persistenceService: MockPersistenceService(),
    );

    expect(displayInput(state.inputBuffer), '');
    expect(exportInput(state.inputBuffer), '');

    controller.input1();
    controller.input1();
    controller.input1();
    controller.inputPeriod();
    controller.input1();
    controller.input1();
    controller.input1();
    expect(displayInput(state.inputBuffer), '111.111');
    expect(exportInput(state.inputBuffer), '111.111');

    await controller.copyInputExportToClipboard();

    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');
    expect(exportInput(state.inputBuffer), '');

    final baseUnit = Category.currency.baseUnit;

    await controller.pasteFromClipboard();
    expect(displayInput(state.inputBuffer), '111.111');
    expect(exportInput(state.inputBuffer), '111.111');
    expect(
      displayOutput(
        state.inputBuffer,
        inputUnit: baseUnit,
        outputUnit: baseUnit,
        roundDecimalPlaces: baseUnit.precision,
      ),
      '111.11',
    );
    expect(
      exportOutput(
        state.inputBuffer,
        inputUnit: baseUnit,
        outputUnit: baseUnit,
        roundDecimalPlaces: baseUnit.precision,
      ),
      '111.11',
    );

    await controller.copyOutputExportToClipboard();

    controller.clearInput();
    expect(displayInput(state.inputBuffer), '');
    expect(exportInput(state.inputBuffer), '');

    await controller.pasteFromClipboard();
    expect(displayInput(state.inputBuffer), '111.11');
    expect(exportInput(state.inputBuffer), '111.11');
  });

  test('Check setColorSchemeSeed()', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    expect(state.colorSchemeSeed.value, isNot(Colors.black.value));

    controller.setColorSchemeSeed(Colors.black);
    expect(state.colorSchemeSeed.value, Colors.black.value);
    verify(persistenceService.storeColorSchemeSeed(Colors.black));
  });

  test('Check setThemeMode()', () {
    final state = AppState();
    final persistenceService = MockPersistenceService();
    final controller = Controller(
      state: state,
      persistenceService: persistenceService,
    );

    expect(state.themeMode, ThemeMode.system);

    controller.setThemeMode(ThemeMode.dark);
    expect(state.themeMode, ThemeMode.dark);
    verify(persistenceService.storeThemeMode(ThemeMode.dark));
  });
}
