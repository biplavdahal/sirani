import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class SelectorWidget extends StatelessWidget {
  final List<String> items;
  final List<String> response;
  final String selectedItem;
  final ValueChanged<String>? onChanged;

  const SelectorWidget({
    Key? key,
    required this.items,
    required this.response,
    required this.selectedItem,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColor.primary),
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        children: [
          for (int i = 0; i < items.length; i++)
            ChoiceChip(
              elevation: 0,
              pressElevation: 0,
              tooltip: items[i],
              backgroundColor: AppColor.primary,
              labelStyle: TextStyle(
                color: response[i] == selectedItem
                    ? AppColor.primary
                    : Colors.white,
              ),
              label: Text(items[i]),
              selected: response[i] == selectedItem,
              onSelected: (bool selected) {
                onChanged!(response[i]);
              },
            ),
        ],
      ),
    );
  }
}
