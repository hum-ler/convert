import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:convert_unit/widgets/currency_display.dart';
import 'package:convert_unit/widgets/unit_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A display for the currently chosen [Category].
class CategoryDisplay extends StatelessWidget {
  const CategoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final category = context.select((AppState state) => state.category);

    switch (category) {
      case Category.time:
        return UnitDisplay(
          key: const Key('time-display'),
          units: Category.time.units,
        );

      case Category.length:
        return UnitDisplay(
          key: const Key('length-display'),
          units: Category.length.units,
        );

      case Category.weight:
        return UnitDisplay(
          key: const Key('weight-display'),
          units: Category.weight.units,
        );

      case Category.speed:
        return UnitDisplay(
          key: const Key('speed-display'),
          units: Category.speed.units,
        );

      case Category.area:
        return UnitDisplay(
          key: const Key('area-display'),
          units: Category.area.units,
        );

      case Category.volume:
        return UnitDisplay(
          key: const Key('volume-display'),
          units: Category.volume.units,
        );

      case Category.temperature:
        return UnitDisplay(
          key: const Key('temperature-display'),
          units: Category.temperature.units,
        );

      case Category.currency:
        return const CurrencyDisplay();

      default:
        return const Placeholder();
    }
  }
}
