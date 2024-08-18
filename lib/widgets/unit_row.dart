import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A row representing a chosen [Unit] and its current [value].
class UnitRow extends StatefulWidget {
  const UnitRow({
    super.key,
    this.color,
    required this.units,
    required this.initialIndex,
    required this.value,
    required this.updateUnit,
    this.onUnitSelected,
    this.onValueLongPress,
  });

  final Color? color;

  final List<Unit> units;

  final int initialIndex;

  final String value;

  /// Checks for an updated [Unit] when AppState notifies a change.
  ///
  /// Works around CarouselSlider not responding to initialPage changes.
  final Unit Function(AppState) updateUnit;

  final void Function(Unit?)? onUnitSelected;

  final void Function()? onValueLongPress;

  @override
  State<UnitRow> createState() => _UnitRowState();
}

class _UnitRowState extends State<UnitRow> {
  late Unit _unit;

  final _carouselSliderController = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    _unit = widget.units[widget.initialIndex];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Work around CarouselSlider not updating to initialPage change.
    final state = context.watch<AppState>();

    if (_unit != widget.updateUnit(state)) {
      _unit = widget.updateUnit(state);

      if (_carouselSliderController.ready) {
        _carouselSliderController.animateToPage(widget.units.indexOf(_unit));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            height: 40.0,
            width: 120.0,
            child: CarouselSlider(
              items: widget.units.map((unit) {
                return Text(
                  unit.name,
                  style: TextStyle(fontSize: 20.0, color: widget.color),
                );
              }).toList(),
              options: CarouselOptions(
                scrollDirection: Axis.vertical,
                height: 40.0,
                viewportFraction: 1.2,
                initialPage: widget.initialIndex,
                onPageChanged: (index, reason) {
                  if (reason == CarouselPageChangedReason.manual) {
                    setState(() => _unit = widget.units[index]);
                    widget.onUnitSelected!(widget.units[index]);
                  }
                },
              ),
              controller: _carouselSliderController,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 12.0)),
          GestureDetector(
            onLongPress: widget.onValueLongPress,
            child: SizedBox(
              // 156.0 = 12.0 (padding) * 3 + 120.0 (carousel)
              width: MediaQuery.of(context).size.width - 156.0,
              height: 62.0,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${widget.value} ${_unit.symbol}',
                    textScaler: const TextScaler.linear(4.0),
                    style: TextStyle(color: widget.color),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
