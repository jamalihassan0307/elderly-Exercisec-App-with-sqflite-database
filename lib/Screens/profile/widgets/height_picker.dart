import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/widgets/dialog_box_button.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  final Function(String) height;
  final String initialValue;
  const HeightPicker(
      {Key? key, required this.height, required this.initialValue})
      : super(key: key);

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  double heightValue = 150.0;
  bool isInitialValue = false;
  late int fixedScoll;

  @override
  void initState() {
    setState(() {
      if (widget.initialValue.isNotEmpty) {
        isInitialValue = true;

        fixedScoll = double.parse(widget.initialValue).round(); //- 50
      } else {
        isInitialValue = false;
        fixedScoll = heightValue.round();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4 * SizeConfig.height!),
        ),
      ),
      child: CustomPicker(
        child: Padding(
          padding: EdgeInsets.all(2.5 * SizeConfig.height!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Height',
                style: TextStyle(
                  color: black.withOpacity(0.7),
                  fontSize: 2.5 * SizeConfig.text!,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
              h20,
              Text(
                'Please select your height it is also used for BMI calculations.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black.withOpacity(0.4),
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
              h20,
              SizedBox(
                height: 10 * SizeConfig.height!,
                width: 28 * SizeConfig.height!,
                child: Row(
                  children: [
                    SizedBox(
                      width: 12 * SizeConfig.height!,
                      child: CupertinoPicker.builder(
                        childCount: 500,
                        scrollController: FixedExtentScrollController(
                            initialItem: fixedScoll),
                        itemExtent: 6 * SizeConfig.height!,
                        selectionOverlay: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: blue, width: 1),
                              bottom: BorderSide(color: blue, width: 1),
                            ),
                          ),
                        ),
                        onSelectedItemChanged: (value) {
                          setState(() =>
                              heightValue = double.parse(value.toString()));
                        },
                        itemBuilder: (itemBuilder, index) {
                          return Center(
                            child: Text(
                              '$index',
                              style: TextStyle(
                                color: black.withOpacity(0.7),
                                fontSize: 2.5 * SizeConfig.text!,
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    w20,
                    Container(
                      width: 12 * SizeConfig.height!,
                      height: 6 * SizeConfig.height!,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: blue, width: 1),
                          bottom: BorderSide(color: blue, width: 1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'cm',
                          style: TextStyle(
                            color: black.withOpacity(0.7),
                            fontSize: 2.5 * SizeConfig.text!,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              h30,
              DialogBoxButton(
                onTap: () {
                  //  if (isInitialValue) {
                  //   setState(() => heightValue = 50.0 + fixedScoll);
                  //   widget.height(heightValue.toString());
                  // }
                  widget.height(heightValue.toString());
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
      ),
    );
  }
}
