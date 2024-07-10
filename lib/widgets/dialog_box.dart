import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/widgets/dialog_box_button.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String? subTitle;

  final Function() onContinue;
  const AppDialog({
    Key? key,
    this.title,
    this.subTitle,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(3 * SizeConfig.height!),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2 * SizeConfig.height!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              style: TextStyle(
                color: black.withOpacity(0.6),
                letterSpacing: 0.7,
                fontSize: 2.5 * SizeConfig.text!,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            Text(
              subTitle ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black.withOpacity(0.4),
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            DialogBoxButton(
              onTap: onContinue,
              btnTxt: 'Continue',
            ),
            DialogBoxButton(
              onTap: () {
                Navigator.pop(context);
              },
              btnTxt: 'Cancel',
              fontColor: darkBlue,
              color: red.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
