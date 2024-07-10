import 'package:flutter/widgets.dart';

import '../shared/utils.dart' show TextFormatter;

class DaysOfWeekStyle {
  final TextFormatter? dowTextFormatter;

  final Decoration decoration;

  final TextStyle weekdayStyle;

  final TextStyle weekendStyle;

  const DaysOfWeekStyle({
    this.dowTextFormatter,
    this.decoration = const BoxDecoration(),
    this.weekdayStyle = const TextStyle(color: Color(0xFF4F4F4F)),
    this.weekendStyle = const TextStyle(color: Color(0xFF6A6A6A)),
  });
}
