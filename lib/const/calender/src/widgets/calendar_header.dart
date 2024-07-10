import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_icon_button.dart';

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;

  const CalendarHeader({
    Key? key,
    this.locale,
    required this.focusedMonth,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = DateFormat.yMMMM(locale).format(focusedMonth);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: const Icon(Icons.chevron_left),
            onTap: onLeftChevronTap,
            padding: const EdgeInsets.all(12.0),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 17.0),
            textAlign: TextAlign.center,
          ),
          CustomIconButton(
            icon: const Icon(Icons.chevron_right),
            onTap: onRightChevronTap,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }
}
