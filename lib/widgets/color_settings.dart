import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The settings for app color scheme.
class ColorSettings extends StatelessWidget {
  static const availableColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  const ColorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorValue = context.select((AppState state) {
      return state.colorSchemeSeed.value;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: availableColors.map(
        (color) {
          return ColorSelection(
            color: color,
            isSelected: color.value == colorValue,
          );
        },
      ).toList(),
    );
  }
}

class ColorSelection extends StatelessWidget {
  const ColorSelection({
    super.key,
    required this.color,
    this.isSelected = false,
  });

  final Color color;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected
          ? null
          : () => context.read<Controller>().setColorSchemeSeed(color),
      child: Stack(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: isSelected ? const Icon(Icons.check) : null,
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
        ],
      ),
    );
  }
}
