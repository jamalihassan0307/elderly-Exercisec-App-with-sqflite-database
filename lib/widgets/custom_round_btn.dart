import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:flutter/material.dart';

class CustomRoundBtn extends StatelessWidget {
  final Function() onTap;
  final String text;
  const CustomRoundBtn({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3 * SizeConfig.height!,
          vertical: 1.2 * SizeConfig.height!,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5 * SizeConfig.height!),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[blue, darkBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.4),
              offset: const Offset(0, 10),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: white,
              fontSize: 2.7 * SizeConfig.text!,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
