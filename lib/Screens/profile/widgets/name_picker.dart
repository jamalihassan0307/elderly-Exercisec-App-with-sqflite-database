import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/widgets/dialog_box_button.dart';
import 'package:flutter/material.dart';

class NamePicker extends StatefulWidget {
  final Function(String) getName;
  final String name;
  const NamePicker({Key? key, required this.getName, required this.name})
      : super(key: key);

  @override
  State<NamePicker> createState() => _NamePickerState();
}

class _NamePickerState extends State<NamePicker> {
  TextEditingController controller = TextEditingController();
  // bool isInitialValue = false;

  // @override
  // void initState() {
  //   setState(() {
  //     if (widget.name.isNotEmpty) {
  //       isInitialValue = true;
  //     } else {
  //       isInitialValue = false;
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4 * SizeConfig.height!),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.5 * SizeConfig.height!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your name',
              style: TextStyle(
                color: black.withOpacity(0.7),
                fontSize: 2.5 * SizeConfig.text!,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            Text(
              'Enter your name in the box below for recognized yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black.withOpacity(0.4),
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            Container(
              height: 6 * SizeConfig.height!,
              width: 35 * SizeConfig.height!,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: grey.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.05),
                    offset: const Offset(0, 10),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: TextFormField(
                controller: controller,
                autofocus: true,
                style: TextStyle(
                  color: blue,
                  letterSpacing: 0.7,
                  fontSize: 2.5 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.name,
                  hintStyle: TextStyle(
                    color: blue,
                    letterSpacing: 0.7,
                    fontSize: 2.5 * SizeConfig.text!,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            h30,
            DialogBoxButton(
              onTap: () {
                // setState(() {
                //   if (isInitialValue) {
                //     controller.text = widget.name;
                //   }
                // });
                widget.getName(
                    controller.text.isEmpty ? widget.name : controller.text);
                // print(controller.text);

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
