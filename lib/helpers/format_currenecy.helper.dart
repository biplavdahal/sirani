import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final _cur = NumberFormat("#,##0", "en_US");

  return _cur.format(amount);
}
