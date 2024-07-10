import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/widgets/dialog_box_button.dart';
import 'package:flutter/material.dart';

class GenderPicker extends StatefulWidget {
  final Function(String) gender;
  const GenderPicker({Key? key, required this.gender}) : super(key: key);

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  late int groupValue = 1;
  String genderN = 'Male';
  void selectedGender(int value, String gender) {
    setState(() {
      groupValue = value;
      genderN = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4 * SizeConfig.height!),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2 * SizeConfig.height!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select your gender',
              style: TextStyle(
                color: black.withOpacity(0.7),
                fontSize: 2.6 * SizeConfig.text!,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            Text(
              'Select your gender below to recognize yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black.withOpacity(0.4),
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            ListTile(
              title: const Text('Male'),
              leading: Radio(
                  value: 1,
                  groupValue: groupValue,
                  activeColor: blue,
                  onChanged: (int? value) {
                    selectedGender(value!, 'Male');
                  }),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio(
                  value: 2,
                  groupValue: groupValue,
                  activeColor: blue,
                  onChanged: (int? value) {
                    selectedGender(value!, 'Female');
                  }),
            ),
            h30,
            DialogBoxButton(
              onTap: () {
                widget.gender(genderN);
                Navigator.pop(context);
              },
              btnTxt: 'Coutinue',
            ),
            DialogBoxButton(
              onTap: () {
                Navigator.pop(context);
              },
              fontColor: darkBlue,
              color: red.withOpacity(0.7),
              btnTxt: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }
}
