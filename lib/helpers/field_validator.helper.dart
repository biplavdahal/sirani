import 'package:bestfriend/bestfriend.dart';

class FieldValidator extends Validators {
  static String? isRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }

    return null;
  }
}
