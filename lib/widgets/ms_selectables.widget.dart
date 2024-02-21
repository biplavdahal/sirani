import 'package:flutter/material.dart';

class MSSelectables<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) unSelectedWidget;
  final Widget Function(T item) selectedWidget;
  final ValueSetter<T> onSelected;
  final T value;

  const MSSelectables({
    Key? key,
    required this.items,
    required this.value,
    required this.unSelectedWidget,
    required this.selectedWidget,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List.generate(
        items.length,
        (index) {
          if (items[index] == value) {
            return selectedWidget(items[index]);
          } else {
            return unSelectedWidget(items[index]);
          }
        },
      ),
    );
  }
}
