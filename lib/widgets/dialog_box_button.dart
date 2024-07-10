import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:flutter/material.dart';

class DialogBoxButton extends StatelessWidget {
  final Function() onTap;
  final String btnTxt;
  final Color? color;
  final Color? fontColor;
  const DialogBoxButton({
    Key? key,
    required this.onTap,
    required this.btnTxt,
    this.color,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 5 * SizeConfig.height!,
        margin: EdgeInsets.only(bottom: 1.2 * SizeConfig.height!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3 * SizeConfig.height!),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[color ?? blue, color ?? darkBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.3),
              offset: const Offset(0, 10),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            btnTxt,
            style: TextStyle(
              color: white,
              fontSize: 2.5 * SizeConfig.text!,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
