import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The settings for app theme.
class ModeSettings extends StatelessWidget {
  const ModeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchemeSeed = context.select((AppState state) {
      return state.colorSchemeSeed;
    });
    final themeMode = context.select((AppState state) => state.themeMode);

    final lightColor = ColorScheme.fromSeed(
      seedColor: colorSchemeSeed,
      brightness: Brightness.dark,
    ).primary;
    final darkColor = ColorScheme.fromSeed(
      seedColor: colorSchemeSeed,
      brightness: Brightness.light,
    ).primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LightModeSelection(
          color: lightColor,
          isSelected: themeMode == ThemeMode.light,
          onSelect: () {
            context.read<Controller>().setThemeMode(ThemeMode.light);
          },
        ),
        SystemThemeSelection(
          lightColor: lightColor,
          darkColor: darkColor,
          isSelected: themeMode == ThemeMode.system,
          onSelect: () {
            context.read<Controller>().setThemeMode(ThemeMode.system);
          },
        ),
        DarkModeSelection(
          color: darkColor,
          isSelected: themeMode == ThemeMode.dark,
          onSelect: () {
            context.read<Controller>().setThemeMode(ThemeMode.dark);
          },
        ),
      ],
    );
  }
}

class LightModeSelection extends StatelessWidget {
  const LightModeSelection({
    super.key,
    required this.color,
    this.isSelected = false,
    required this.onSelect,
  });

  final Color color;

  final bool isSelected;

  final void Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onSelect,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Container(
            height: 40.0,
            width: 40.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 4.0,
                ),
              ),
            ),
          ),
          const Icon(Icons.light_mode, color: Colors.black),
        ],
      ),
    );
  }
}

class DarkModeSelection extends StatelessWidget {
  const DarkModeSelection({
    super.key,
    required this.color,
    this.isSelected = false,
    required this.onSelect,
  });

  final Color color;

  final bool isSelected;

  final void Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onSelect,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Container(
            height: 40.0,
            width: 40.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 4.0,
                ),
              ),
            ),
          ),
          const Icon(Icons.dark_mode, color: Colors.white),
        ],
      ),
    );
  }
}

class SystemThemeSelection extends StatelessWidget {
  const SystemThemeSelection({
    super.key,
    required this.lightColor,
    required this.darkColor,
    this.isSelected = false,
    required this.onSelect,
  });

  final Color lightColor;

  final Color darkColor;

  final bool isSelected;

  final void Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onSelect,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                  color: lightColor,
                ),
                width: 20.0,
                height: 40.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.zero,
                    topLeft: Radius.zero,
                  ),
                  color: darkColor,
                ),
                width: 20.0,
                height: 40.0,
              ),
            ],
          ),
          Container(
            height: 40.0,
            width: 40.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).iconTheme.color!
                      : Colors.transparent,
                  width: 4.0,
                ),
              ),
            ),
          ),
          const Icon(Icons.brightness_auto),
        ],
      ),
    );
  }
}
