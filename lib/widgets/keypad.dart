import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A grid of buttons for user input.
class Keypad extends StatelessWidget {
  const Keypad({super.key});

  void showSnackBarMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary.withAlpha(64),
      child: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(12.0),
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          CircularButton(
            label: 'C',
            onPressed: () => context.read<Controller>().clearInput(),
            useSecondaryColor: true,
          ),
          CircularButton(
            label: 'Bookmark 1',
            onPressed: () => context.read<Controller>().loadBookmark1(),
            onLongPress: () {
              context.read<Controller>().saveBookmark1();
              showSnackBarMessage(context, 'Bookmark 1 saved');
            },
            useSecondaryColor: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.bookmark, size: 32.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircularButton(
            label: 'Bookmark 2',
            onPressed: () => context.read<Controller>().loadBookmark2(),
            onLongPress: () {
              context.read<Controller>().saveBookmark2();
              showSnackBarMessage(context, 'Bookmark 2 saved');
            },
            useSecondaryColor: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.bookmark, size: 32.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircularButton(
            label: 'Swap units',
            onPressed: () => context.read<Controller>().swapUnits(),
            useSecondaryColor: true,
            child: const Icon(Icons.swap_vert, size: 32.0),
          ),
          CircularButton(
            label: '7',
            onPressed: () => context.read<Controller>().input7(),
          ),
          CircularButton(
            label: '8',
            onPressed: () => context.read<Controller>().input8(),
          ),
          CircularButton(
            label: '9',
            onPressed: () => context.read<Controller>().input9(),
          ),
          CircularButton(
            label: 'Clipboard',
            onPressed: () => context.read<Controller>().pasteFromClipboard(),
            useSecondaryColor: true,
            child: const Icon(Icons.content_paste, size: 32.0),
          ),
          CircularButton(
            label: '4',
            onPressed: () => context.read<Controller>().input4(),
          ),
          CircularButton(
            label: '5',
            onPressed: () => context.read<Controller>().input5(),
          ),
          CircularButton(
            label: '6',
            onPressed: () => context.read<Controller>().input6(),
          ),
          CircularButton(
            label: '+10%',
            onPressed: () => context.read<Controller>().add10Percent(),
            useSecondaryColor: true,
            child: const Text('+10%', textScaler: TextScaler.linear(1.2)),
          ),
          CircularButton(
            label: '1',
            onPressed: () => context.read<Controller>().input1(),
          ),
          CircularButton(
            label: '2',
            onPressed: () => context.read<Controller>().input2(),
          ),
          CircularButton(
            label: '3',
            onPressed: () => context.read<Controller>().input3(),
          ),
          CircularButton(
            label: '+20%',
            onPressed: () => context.read<Controller>().add20Percent(),
            useSecondaryColor: true,
            child: const Text('+20%', textScaler: TextScaler.linear(1.2)),
          ),
          CircularButton(
            label: '0',
            onPressed: () => context.read<Controller>().input0(),
          ),
          CircularButton(
            label: '.',
            onPressed: () => context.read<Controller>().inputPeriod(),
          ),
          CircularButton(
            label: 'Backspace',
            onPressed: () => context.read<Controller>().deleteLastInput(),
            useSecondaryColor: true,
            child: const Icon(Icons.backspace, size: 32.0),
          ),
          CircularButton(
            label: 'Settings',
            onPressed: () =>
                context.read<Controller>().openSettingsPage(context),
            useSecondaryColor: true,
            child: const Icon(Icons.settings, size: 32.0),
          ),
        ],
      ),
    );
  }
}
