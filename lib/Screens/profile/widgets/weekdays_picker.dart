import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/database/app_db.dart';
import 'package:ex_app/data/model/alarm.dart';
import 'package:ex_app/widgets/dialog_box_button.dart';
import 'package:flutter/material.dart';

class WeekDaysPicker extends StatefulWidget {
  final String weekId;
  final bool? isUpdate;
  const WeekDaysPicker({Key? key, this.isUpdate, required this.weekId})
      : super(key: key);

  @override
  State<WeekDaysPicker> createState() => _WeekDaysPickerState();
}

class _WeekDaysPickerState extends State<WeekDaysPicker> {
  List items = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  List selectedItems = [];
  List getSelect = [];
  List getOrderIndex = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    getSelect = await ExerciseDatabase.instance.readArlam(widget.weekId);
    if (mounted) {}
    for (int k = 0; k < getSelect.length; k++) {
      setState(() {
        selectedItems.add(getSelect[k].week);
        getOrderIndex.add(getSelect[k].setOrder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4 * SizeConfig.height!),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.5 * SizeConfig.height!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Days',
                style: TextStyle(
                  color: black.withOpacity(0.6),
                  letterSpacing: 0.7,
                  fontSize: 2.5 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                ),
              ),
              h20,
              Text(
                'Please select days it used to repeat reminders.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black.withOpacity(0.4),
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
              h20,
              SizedBox(
                height: 50 * SizeConfig.height!,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: items.map((item) {
                    bool isSelected = selectedItems.contains(item);
                    return CheckboxListTile(
                      activeColor: blue,
                      checkColor: white,
                      title: Text(
                        item,
                        style: TextStyle(
                          color: black.withOpacity(0.6),
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedItems.add(item);
                            getOrderIndex.add(items.indexOf(item));
                            // print(items.indexOf(item));

                          } else {
                            selectedItems.remove(item);
                            getOrderIndex.remove(items.indexOf(item));
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              h30,
              DialogBoxButton(
                onTap: () {
                  if (widget.isUpdate == true) {
                    ExerciseDatabase.instance.deleteRepeat(widget.weekId);
                  }

                  for (int i = 0; i < selectedItems.length; i++) {
                    var insertRepeat = RepateAlarm(
                      setOrder: getOrderIndex[i],
                      week: selectedItems[i],
                      weekID: widget.weekId,
                    );
                    ExerciseDatabase.instance.insertRepeat(insertRepeat);
                  }
                  Navigator.pop(context);
                },
                btnTxt: 'Continue',
              ),
              DialogBoxButton(
                onTap: () {
                  Navigator.pop(context);
                },
                btnTxt: 'Cancel',
                fontColor: white,
                color: red.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CheckboxListTile customListtile(
      String item, bool isSelected, Function(bool?) onChanged) {
    return CheckboxListTile(
      activeColor: blue,
      checkColor: white,
      title: Text(
        item,
        style: TextStyle(
          color: black.withOpacity(0.6),
          letterSpacing: 0.7,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}
