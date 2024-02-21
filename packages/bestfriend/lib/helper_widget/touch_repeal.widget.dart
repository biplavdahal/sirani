import 'package:flutter/material.dart';

class TouchRepeal extends StatelessWidget {
  final Widget child;

  TouchRepeal({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: this.child,
    );
  }
}
