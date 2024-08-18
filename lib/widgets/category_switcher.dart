import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:convert_unit/controllers/controller.dart';
import 'package:convert_unit/models/app_state.dart';
import 'package:convert_unit/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A slider for changing [Category]s.
class CategorySwitcher extends StatelessWidget {
  const CategorySwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: Category.values.map((category) {
        return CategoryItem(icon: category.icon, label: category.label);
      }).toList(),
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          if (reason == CarouselPageChangedReason.manual) {
            context.read<Controller>().setCategory(Category.values[index]);
          }
        },
        initialPage: Category.values.indexOf(
          context.select((AppState state) => state.category),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(width: 4.0),
        Icon(icon),
      ],
    );
  }
}
