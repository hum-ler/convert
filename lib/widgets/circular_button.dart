import 'package:flutter/material.dart';

/// A circular filled button.
class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.useSecondaryColor = false,
    this.child,
  });

  final String label;

  final void Function()? onPressed;

  final void Function()? onLongPress;

  final bool useSecondaryColor;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: useSecondaryColor
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: FittedBox(
        fit: BoxFit.none,
        child: child ?? Text(label, textScaler: const TextScaler.linear(2.4)),
      ),
    );
  }
}
