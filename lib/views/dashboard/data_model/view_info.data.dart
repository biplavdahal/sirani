import 'package:flutter/cupertino.dart';

class ViewInfoData {
  final String title;
  final bool showShowMoreOption;
  final Widget view;

  ViewInfoData({
    required this.title,
    required this.view,
    this.showShowMoreOption = false,
  });
}
