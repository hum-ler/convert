import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/services/persistence_service.dart';
import 'package:convert_unit/utilities/utilities.dart';
import 'package:convert_unit/widgets/color_settings.dart';
import 'package:convert_unit/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SettingsDialog smoke test', (WidgetTester tester) async {
    final state = AppState();

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            Provider(
              create: (_) => Controller(
                state: state,
                persistenceService: PersistenceService(),
              ),
            ),
            ChangeNotifierProvider.value(value: state),
          ],
          child: const SettingsDialog(),
        ),
      ),
    );

    final selection = find.ancestor(
      matching: find.byType(ColorSelection),
      of: find.byIcon(Icons.check),
    );
    expect(selection, findsOneWidget);
    expect(
      (tester.widget(selection) as ColorSelection)
          .color
          .isSameColorAs(Colors.indigo),
      isFalse,
    );

    final indigo = ColorSelectionFinder(Colors.indigo);
    expect(indigo, findsOneWidget);
    await tester.tap(indigo);
    await tester.pump();

    expect(selection, findsOneWidget);
    expect(
      (tester.widget(selection) as ColorSelection)
          .color
          .isSameColorAs(Colors.indigo),
      isTrue,
    );
  });
}

class ColorSelectionFinder extends MatchFinder {
  ColorSelectionFinder(this.color, {super.skipOffstage});

  final Color color;

  @override
  String get description => 'ColorSelection of color $color';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is! ColorSelection) return false;

    final selection = candidate.widget as ColorSelection;
    return selection.color.isSameColorAs(color);
  }
}
