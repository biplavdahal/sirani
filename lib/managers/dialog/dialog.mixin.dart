import 'package:bestfriend/bestfriend.dart';
import 'package:mysirani/managers/dialog/dialog.service.dart';

mixin DialogMixin {
  final DialogService dialog = locator<DialogService>();
}
