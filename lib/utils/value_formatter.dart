import 'package:intl/intl.dart';

abstract class ValueFormatter {
  String format(double value);
}

class DecimalFormatter extends ValueFormatter {
  DecimalFormatter({
    this.count = 0,
  });

  final int count;

  @override
  String format(double value) {
    String format = "#,##0";
    for(int i = 0; i < count; i++) {
      if (i == 0) {
        format += ".";
      }
      format += "0";
    }
    return NumberFormat(format).format(value);
  }
}