import 'package:flutter/material.dart';

class CustomPicker extends StatelessWidget {
  final Widget child;
  const CustomPicker({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: child,
    );
  }
}
