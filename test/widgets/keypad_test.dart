import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/widgets/circular_button.dart';
import 'package:convert_unit/widgets/keypad.dart';
import 'package:convert_unit/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<Controller>()])
import 'keypad_test.mocks.dart';

void main() {
  final mockController = MockController();

  testWidgets('All buttons are drawn', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: Provider.value(
          value: mockController,
          child: const Keypad(),
        ),
      ),
    );

    expect(find.byType(CircularButton), findsNWidgets(20));

    expect(find.text('C'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNWidgets(2));
    expect(find.byIcon(Icons.swap_vert), findsOneWidget);

    expect(find.text('7'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.byIcon(Icons.paste), findsOneWidget);

    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('+10%'), findsOneWidget);

    expect(find.text('1'), findsNWidgets(2));
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('+20%'), findsOneWidget);

    expect(find.text('0'), findsOneWidget);
    expect(find.text('.'), findsOneWidget);
    expect(find.byIcon(Icons.backspace), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets(
    'All buttons are wired to controller',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                Provider<Controller>.value(value: mockController),
                ChangeNotifierProvider(create: (_) => AppState()),
              ],
              child: const Keypad(),
            ),
          ),
        ),
      );

      reset(mockController);
      await tester.tap(find.text('C'));
      verify(mockController.clearInput());

      final bookmarkButtons = find.ancestor(
        of: find.byIcon(Icons.bookmark),
        matching: find.byType(CircularButton),
      );
      expect(bookmarkButtons, findsNWidgets(2));

      reset(mockController);
      await tester.tap(bookmarkButtons.at(0));
      await tester.tap(bookmarkButtons.at(1));
      verify(mockController.loadBookmark1());
      verify(mockController.loadBookmark2());

      reset(mockController);
      await tester.longPress(bookmarkButtons.at(0));
      await tester.longPress(bookmarkButtons.at(1));
      verify(mockController.saveBookmark1());
      verify(mockController.saveBookmark2());

      reset(mockController);
      await tester.tap(find.byIcon(Icons.swap_vert));
      verify(mockController.swapUnits());

      reset(mockController);
      await tester.tap(find.text('7'));
      verify(mockController.input7());

      reset(mockController);
      await tester.tap(find.text('8'));
      verify(mockController.input8());

      reset(mockController);
      await tester.tap(find.text('9'));
      verify(mockController.input9());

      reset(mockController);
      await tester.tap(find.byIcon(Icons.paste));
      verify(mockController.pasteFromClipboard());

      reset(mockController);
      await tester.tap(find.text('4'));
      verify(mockController.input4());

      reset(mockController);
      await tester.tap(find.text('5'));
      verify(mockController.input5());

      reset(mockController);
      await tester.tap(find.text('6'));
      verify(mockController.input6());

      reset(mockController);
      await tester.tap(find.text('+10%'));
      verify(mockController.add10Percent());

      reset(mockController);
      await tester.tap(find.text('1').at(1));
      verify(mockController.input1());

      reset(mockController);
      await tester.tap(find.text('2').at(1));
      verify(mockController.input2());

      reset(mockController);
      await tester.tap(find.text('3'));
      verify(mockController.input3());

      reset(mockController);
      await tester.tap(find.text('+20%'));
      verify(mockController.add20Percent());

      reset(mockController);
      await tester.tap(find.text('0'));
      verify(mockController.input0());

      reset(mockController);
      await tester.tap(find.text('.'));
      verify(mockController.inputPeriod());

      reset(mockController);
      await tester.tap(find.byIcon(Icons.backspace));
      verify(mockController.deleteLastInput());

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsDialog), findsOneWidget);
    },
  );
}
