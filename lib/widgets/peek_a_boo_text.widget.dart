import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';

class PeekABooText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  final int maxLengthOnCollapse;

  const PeekABooText(
    this.text, {
    Key? key,
    this.maxLengthOnCollapse = 250,
    this.style,
  }) : super(key: key);

  @override
  _PeekABooTextState createState() => _PeekABooTextState();
}

class _PeekABooTextState extends State<PeekABooText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.text.length > widget.maxLengthOnCollapse
        ? Text.rich(
            TextSpan(
                text: _isExpanded
                    ? widget.text
                    : "${widget.text.substring(0, widget.maxLengthOnCollapse)}...",
                style: widget.style,
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _onPressed(),
                    text: _isExpanded ? " Show less" : " View more",
                    style: const TextStyle(
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]),
          )
        : Text(
            widget.text,
            style: widget.style,
          );
  }

  void _onPressed() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
