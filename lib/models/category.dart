import 'package:convert_unit/data/area_units.dart';
import 'package:convert_unit/data/exchange_rates.dart';
import 'package:convert_unit/data/length_units.dart';
import 'package:convert_unit/data/speed_units.dart';
import 'package:convert_unit/data/temperature_units.dart';
import 'package:convert_unit/data/time_units.dart';
import 'package:convert_unit/data/volume_units.dart';
import 'package:convert_unit/data/weight_units.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:flutter/material.dart';

/// A [Category] / quantity of measurement.
enum Category {
  time(icon: Icons.access_time, label: 'Time / Duration'),
  length(icon: Icons.straighten, label: 'Length / Distance'),
  weight(icon: Icons.scale, label: 'Weight'),
  speed(icon: Icons.directions_run, label: 'Speed'),
  area(icon: Icons.grid_on, label: 'Area'),
  volume(icon: Icons.view_in_ar, label: 'Volume'),
  temperature(icon: Icons.thermostat, label: 'Temperature'),
  currency(icon: Icons.monetization_on, label: 'Currency');

  const Category({required this.icon, required this.label});

  final IconData icon;

  final String label;

  /// Retrieves all the [Unit]s for this [Category].
  List<Unit> get units {
    switch (this) {
      case Category.time:
        return TimeUnits.units;

      case Category.length:
        return LengthUnits.units;

      case Category.weight:
        return WeightUnits.units;

      case Category.speed:
        return SpeedUnits.units;

      case Category.area:
        return AreaUnits.units;

      case Category.volume:
        return VolumeUnits.units;

      case Category.temperature:
        return TemperatureUnits.units;

      case Category.currency:
        return ExchangeRates.currencies;
    }
  }

  /// Retrieves the base [Unit] for this [Category].
  Unit get baseUnit {
    switch (this) {
      case Category.time:
        return TimeUnits.baseUnit;

      case Category.length:
        return LengthUnits.baseUnit;

      case Category.weight:
        return WeightUnits.baseUnit;

      case Category.speed:
        return SpeedUnits.baseUnit;

      case Category.area:
        return AreaUnits.baseUnit;

      case Category.volume:
        return VolumeUnits.baseUnit;

      case Category.temperature:
        return TemperatureUnits.baseUnit;

      case Category.currency:
        return ExchangeRates.baseCurrency;
    }
  }

  /// Retrieves a [Unit] using its unique [code].
  Unit fromCode(String code) {
    switch (this) {
      case Category.time:
        return TimeUnits.fromCode(code);

      case Category.length:
        return LengthUnits.fromCode(code);

      case Category.weight:
        return WeightUnits.fromCode(code);

      case Category.speed:
        return SpeedUnits.fromCode(code);

      case Category.area:
        return AreaUnits.fromCode(code);

      case Category.volume:
        return VolumeUnits.fromCode(code);

      case Category.temperature:
        return TemperatureUnits.fromCode(code);

      case Category.currency:
        return ExchangeRates.fromCode(code);
    }
  }

  /// Retrieves a [Unit] using its unique [code].
  Unit? tryFromCode(String code) {
    switch (this) {
      case Category.time:
        return TimeUnits.tryFromCode(code);

      case Category.length:
        return LengthUnits.tryFromCode(code);

      case Category.weight:
        return WeightUnits.tryFromCode(code);

      case Category.speed:
        return SpeedUnits.tryFromCode(code);

      case Category.area:
        return AreaUnits.tryFromCode(code);

      case Category.volume:
        return VolumeUnits.tryFromCode(code);

      case Category.temperature:
        return TemperatureUnits.tryFromCode(code);

      case Category.currency:
        return ExchangeRates.tryFromCode(code);
    }
  }
}
