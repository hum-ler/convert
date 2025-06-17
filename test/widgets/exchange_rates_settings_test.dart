import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/widgets/exchange_rates_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<Controller>(), MockSpec<AppState>()])
import 'exchange_rates_settings_test.mocks.dart';

void main() {
  final lastUpdated = ExchangeRates.lastUpdated.toString().split(" ").first;

  final mockController = MockController();
  final mockState = MockAppState();

  setUpAll(() {
    when(mockState.currenciesLastUpdated).thenReturn(ExchangeRates.lastUpdated);
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
            child: const ExchangeRatesSettings(),
          ),
        ),
      ),
    );

    expect(
      find.text('Exchange rates downloaded on $lastUpdated:'),
      findsOneWidget,
    );
    expect(find.text('Sign in | Update'), findsOneWidget);

    expect(find.text('SGD/EUR'), findsOneWidget);
    expect(
      find.text(ExchangeRates.fromCode('EUR').exchangeRate.toString()),
      findsOneWidget,
    );

    // Base currency should be omitted.
    expect(find.text('SGD/SGD'), findsNothing);

    expect(
      find.text(' = '),
      findsNWidgets(ExchangeRates.currencies.length - 1),
    );
  });

  testWidgets('Update button triggers successful update',
      (WidgetTester tester) async {
    // Easier to test with the actual AppState, instead of mocking a ChangeNotifier.
    AppState state = AppState();
    state.currenciesLastUpdated = ExchangeRates.lastUpdated;

    final newLastUpdated = ExchangeRates.lastUpdated.add(Duration(days: 1));

    when(mockController.updateExchangeRates(any)).thenAnswer((_) async {
      ExchangeRates.lastUpdated = newLastUpdated;
      state.currenciesLastUpdated = newLastUpdated;
    });

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MultiProvider(
            providers: [
              Provider<Controller>.value(value: mockController),
              ChangeNotifierProvider<AppState>.value(value: state),
            ],
            child: const Scaffold(
              body: ExchangeRatesSettings(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sign in | Update'));
    await tester.pump();

    expect(
      find.text(
        'Exchange rates updated to ${newLastUpdated.toString().split(" ").first}.',
      ),
      findsOneWidget,
    );

    verify(mockController.updateExchangeRates(any));
  });

  testWidgets('Update button triggers successful non-update',
      (WidgetTester tester) async {
    // Easier to test with the actual AppState, instead of mocking a ChangeNotifier.
    AppState state = AppState();
    state.currenciesLastUpdated = ExchangeRates.lastUpdated;

    when(mockController.updateExchangeRates(any)).thenAnswer((_) async {
      state.currenciesLastUpdated = ExchangeRates.lastUpdated;
    });

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MultiProvider(
            providers: [
              Provider<Controller>.value(value: mockController),
              ChangeNotifierProvider<AppState>.value(value: state),
            ],
            child: const Scaffold(
              body: ExchangeRatesSettings(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sign in | Update'));
    await tester.pump();

    expect(find.text('Exchange rates already up-to-date.'), findsOneWidget);

    verify(mockController.updateExchangeRates(any));
  });

  testWidgets('Update button triggers unsuccessful update',
      (WidgetTester tester) async {
    when(mockController.updateExchangeRates(any))
        .thenAnswer((_) => Future.error('mock'));

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MultiProvider(
            providers: [
              Provider<Controller>.value(value: mockController),
              ChangeNotifierProvider<AppState>.value(value: mockState),
            ],
            child: const Scaffold(
              body: ExchangeRatesSettings(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sign in | Update'));
    await tester.pump();

    expect(
      find.text(
        'Unable to download latest exchange rates. Please try again later.',
      ),
      findsOneWidget,
    );

    verify(mockController.updateExchangeRates(any));
  });
}
