import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final String imagePath;
  final Function() onTap;
  const CustomCircleButton(
      {Key? key, required this.onTap, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 5.5 * SizeConfig.height!,
        width: 5.5 * SizeConfig.height!,
        margin: EdgeInsets.only(
          top: 0.8 * SizeConfig.height!,
          left: 1.2 * SizeConfig.height!,
          bottom: 1.2 * SizeConfig.height!,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.8 * SizeConfig.height!),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.2),
              offset: const Offset(1, 1),
              spreadRadius: 5,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(1.2 * SizeConfig.height!),
          child: Image.asset(
            'assets/icons/$imagePath',
            color: darkBlue,
          ),
        ),
      ),
    );
  }
}
