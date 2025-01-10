import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/currency.dart';
import 'package:convert_unit/services/persistence_service.dart';
import 'package:convert_unit/widgets/category_display.dart';
import 'package:convert_unit/widgets/category_switcher.dart';
import 'package:convert_unit/widgets/keypad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final persistenceService = PersistenceService();
  final state = await initMyApp(persistenceService: persistenceService);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: persistenceService),
        ChangeNotifierProvider.value(value: state),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchemeSeed = context.select((AppState state) {
      return state.colorSchemeSeed;
    });
    final themeMode = context.select((AppState state) => state.themeMode);

    return MaterialApp(
      title: 'Convert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSchemeSeed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSchemeSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Controller(
        state: context.read<AppState>(),
        persistenceService: context.read<PersistenceService>(),
      ),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Row(
            children: [
              Text('Convert '),
              Expanded(child: CategorySwitcher()),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: const CategoryDisplay(),
                ),
              ),
              const Keypad(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Initializes services while splash screen is up.
Future<AppState> initMyApp({
  required PersistenceService persistenceService,
}) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final state = await persistenceService.retrieveState();

  // Set up locale-specific currency format.
  await findSystemLocale();
  final symbols = NumberFormat().symbols;
  state.currencySymbolPosition = symbols.CURRENCY_PATTERN.startsWith('¤')
      ? SymbolPosition.prefix
      : SymbolPosition.postfix;
  state.decimalSeparator = symbols.DECIMAL_SEP;
  state.groupSeparator = symbols.GROUP_SEP;

  FlutterNativeSplash.remove();

  return state;
}
