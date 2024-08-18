import 'package:convert_unit/main.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/services/persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    // By default, the app starts in currency category, with both the input and
    // output currencies set to SGD.

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider(create: (_) => PersistenceService()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const MyApp(),
      ),
    );

    // Perform some simple input, avoid 1 and 2 because these also appear in the
    // bookmark buttons.
    await tester.tap(find.text('3'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('7'));
    await tester.pump();

    expect(find.text(r'$357'), findsNWidgets(2));
  });
}
