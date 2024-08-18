import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:convert_unit/widgets/currency_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<Controller>(), MockSpec<AppState>()])
import 'currency_display_test.mocks.dart';

void main() {
  final sgd = Category.currency.fromCode('SGD') as Currency;

  final mockController = MockController();
  final mockState = MockAppState();

  setUpAll(() {
    when(mockState.inputUnit).thenReturn(sgd);
    when(mockState.outputUnit).thenReturn(sgd);
    when(mockState.inputBuffer).thenReturn('');
  });

  testWidgets('All widgets are drawn', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MultiProvider(
            providers: [
              Provider<Controller>.value(value: mockController),
              ChangeNotifierProvider<AppState>.value(value: mockState),
            ],
            child: const CurrencyDisplay(),
          ),
        ),
      ),
    );

    expect(find.text('${sgd.regionEmoji}  ${sgd.code}'), findsNWidgets(2));
    expect(find.text(sgd.symbol), findsNWidgets(2));
  });

  testWidgets(
    'All widgets are wired to controller',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Scaffold(
              body: MultiProvider(
                providers: [
                  Provider<Controller>.value(value: mockController),
                  ChangeNotifierProvider<AppState>.value(value: mockState),
                ],
                child: const CurrencyDisplay(),
              ),
            ),
          ),
        ),
      );

      // Input currency row

      final inputCurrencyRow = find.byKey(const Key('input-currency-row'));
      expect(inputCurrencyRow, findsOneWidget);

      // Drag downwards, enough to set the previous currency (MYR).
      reset(mockController);
      await tester.drag(
        find.descendant(
          of: inputCurrencyRow,
          matching: find.text('${sgd.regionEmoji}  ${sgd.code}'),
        ),
        const Offset(0.0, 80.0),
      );
      await tester.pump();
      expect(
        verify(mockController.setInputUnit(captureAny)).captured.first,
        Category.currency.fromCode('MYR'),
      );

      reset(mockController);
      await tester.longPress(
        find.descendant(
          of: inputCurrencyRow,
          matching: find.text(sgd.symbol),
        ),
      );
      await tester.pump();
      verify(mockController.copyInputExportToClipboard());

      // Output currency row

      final outputCurrencyRow = find.byKey(const Key('output-currency-row'));
      expect(outputCurrencyRow, findsOneWidget);

      // Drag upwards, enough to set the next currency (USD).
      reset(mockController);
      await tester.drag(
        find.descendant(
          of: outputCurrencyRow,
          matching: find.text('${sgd.regionEmoji}  ${sgd.code}'),
        ),
        const Offset(0.0, -80.0),
      );
      await tester.pump();
      expect(
        verify(mockController.setOutputUnit(captureAny)).captured.first,
        Category.currency.fromCode('USD'),
      );

      reset(mockController);
      await tester.longPress(
        find.descendant(
          of: outputCurrencyRow,
          matching: find.text(sgd.symbol),
        ),
      );
      await tester.pump();
      verify(mockController.copyOutputExportToClipboard());
    },
  );
}
