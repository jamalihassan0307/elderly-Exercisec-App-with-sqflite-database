import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/database/app_db.dart';
import 'package:ex_app/data/model/user.dart';
import 'package:ex_app/pages/profile/widgets/dob_picker.dart';
import 'package:ex_app/pages/profile/widgets/gender_picker.dart';
import 'package:ex_app/pages/profile/widgets/height_picker.dart';
import 'package:ex_app/pages/profile/widgets/name_picker.dart';
import 'package:ex_app/pages/profile/widgets/weight_picker.dart';
import 'package:ex_app/widgets/custom_round_btn.dart';
import 'package:ex_app/widgets/dialog_box.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:ex_app/widgets/warning_dialog_box.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userGender = '';
  String userHeight = '';
  String userweight = '';
  String userDob = '';
  String bmiData = '';
  double bmiValue = 0.0;
  double level = 0.0;
  bool isLoading = false;
  late User? user;
  void bmiCalculation(double value) {
    if (value > 0.0 && value <= 18.49) {
      setState(() {
        bmiData = 'Not meet the standard';
        if (value > 15) {
          level = value * 3;
        } else {
          level = 5;
        }
      });
    } else if (value >= 18.50 && value <= 24.9) {
      setState(() {
        bmiData = 'Normal';
        level = value * 3;
      });
    } else if (value >= 25 && value <= 29.9) {
      setState(() {
        bmiData = 'Overweight';
        if (26 > value) {
          level = value * 7.2;
        } else {
          level = value * 8;
        }
      });
    } else if (value >= 30 && value <= 34.9) {
      setState(() {
        bmiData = 'Obesity Degree 1';

        if (31 > value) {
          level = value * 8.1;
        } else {
          level = value * 8.6;
        }
      });
    } else if (value >= 35 && value <= 39.9) {
      setState(() {
        bmiData = 'Obesity Degree 2';
        if (36 > value) {
          level = value * 8.7;
        } else {
          level = value * 9;
        }
      });
    } else if (value >= 40) {
      setState(() {
        bmiData = 'Obesity Degree 3';
        level = 362;
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    setState(() => isLoading = true);
    user = await ExerciseDatabase.instance.user();
    setState(() => isLoading = false);
    refreshUser();
    if (mounted) setState(() {});
  }

  Future refreshUser() async {
    setState(() {
      userName = user!.name!;
      userGender = user!.gender!;
      userHeight = user!.height!;
      userweight = user!.weight!;
      userDob = user!.birth!;
      bmiValue = double.parse(user!.bmi!);
    });
    bmiCalculation(bmiValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 3 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomPicker(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.2 * SizeConfig.height!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                settingsTile(
                  'Name',
                  'name',
                  userName.isNotEmpty ? userName : '0.0',
                  () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return NamePicker(
                            getName: (p0) {
                              setState(() => userName = p0);

                              ExerciseDatabase.instance
                                  .updateUser('name', userName);
                              getUser();
                            },
                            name: userName,
                          );
                        });
                    getUser();
                  },
                ),
                settingsTile(
                  'Gender',
                  'gender',
                  userGender.isNotEmpty ? userGender : '0.0',
                  () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return GenderPicker(
                            gender: (p0) {
                              setState(() => userGender = p0);
                              ExerciseDatabase.instance
                                  .updateUser('gender', p0);
                              getUser();
                            },
                          );
                        });
                  },
                ),
                settingsTile(
                  'Height',
                  'height',
                  userHeight.isNotEmpty ? '$userHeight cm' : '0.0',
                  () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return HeightPicker(
                            height: (p0) {
                              setState(() => userHeight = p0);
                              ExerciseDatabase.instance
                                  .updateUser('height', p0);
                              getUser();
                            },
                            initialValue: userHeight,
                          );
                        });
                  },
                ),
                settingsTile(
                  'Weight',
                  'weight',
                  userweight.isNotEmpty ? '$userweight kg' : '0.0',
                  () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return WeightPicker(
                            weight: (p0) {
                              setState(() => userweight = p0);
                              ExerciseDatabase.instance
                                  .updateUser('weight', p0);
                              getUser();
                            },
                          );
                        });
                  },
                ),
                settingsTile(
                  'Date of birth',
                  'birthday',
                  userDob.isNotEmpty ? userDob : '0.0',
                  () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return DOBPicker(
                            dob: (p0) {
                              setState(() => userDob = p0);
                              ExerciseDatabase.instance.updateUser('birth', p0);
                              getUser();
                            },
                          );
                        });
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9 * SizeConfig.height!,
                    vertical: 2.5 * SizeConfig.height!,
                  ),
                  child: CustomRoundBtn(
                    onTap: () {
                      if (userHeight.isNotEmpty || userweight.isNotEmpty) {
                        var values = (double.parse(userweight) /
                                (double.parse(userHeight) *
                                    double.parse(userHeight))) *
                            10000;

                        bmiValue = double.parse(values.toStringAsFixed(1));
                        bmiCalculation(bmiValue);
                        ExerciseDatabase.instance
                            .updateUser('bmi', bmiValue.toString());
                        getUser();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const WarningDialogBox(
                                title:
                                    'Please enter your weight and height it must necessarily be used for calculating.',
                              );
                            });
                      }
                    },
                    text: 'Calculate',
                  ),
                ),
                h10,
                Text(
                  'BMI(kg/m2)',
                  style: TextStyle(
                    color: black.withOpacity(0.7),
                    fontSize: 2.5 * SizeConfig.text!,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                h10,
                SizedBox(
                  height: 16 * SizeConfig.height!,
                  child: Stack(
                    children: [
                      Container(
                        height: 7 * SizeConfig.height!,
                        margin: EdgeInsets.only(top: 2.5 * SizeConfig.height!),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            colorTag(
                              color: const Color(0xFFB2D1CF),
                              width: 4.2 * SizeConfig.width!,
                              value: '15',
                            ),
                            w2,
                            colorTag(
                              color: const Color(0xFF4C6C93),
                              width: 8 * SizeConfig.width!,
                              value: '16',
                            ),
                            w2,
                            colorTag(
                              color: const Color(0xFF74DD78),
                              width: 31 * SizeConfig.width!,
                              value: '18.5',
                            ),
                            w2,
                            colorTag(
                              color: const Color(0xFFDCE683),
                              width: 16 * SizeConfig.width!,
                              value: '25',
                            ),
                            w2,
                            colorTag(
                              color: const Color(0xFFFEB447),
                              width: 16 * SizeConfig.width!,
                              value: '30',
                            ),
                            w2,
                            colorTag(
                                color: const Color(0xFFEA4450),
                                width: 16 * SizeConfig.width!,
                                value: '35',
                                value2: '40'),
                          ],
                        ),
                      ),
                      bmiValue != 0.0
                          ? Positioned(
                              top: 0,
                              left: level > 37
                                  ? level - 4 * SizeConfig.width!
                                  : level,
                              child: Text(
                                bmiValue.toString(),
                                style: TextStyle(
                                  color: black.withOpacity(0.6),
                                  fontSize: 1.7 * SizeConfig.text!,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Positioned(
                        top: 1.8 * SizeConfig.height!,
                        left: bmiValue != 0.0 ? level : 0.5 * SizeConfig.width!,
                        child: Container(
                          width: 2.0,
                          color: black,
                          height: 6.2 * SizeConfig.height!,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          bmiData,
                          style: TextStyle(
                            color: black.withOpacity(0.7),
                            letterSpacing: 0.3,
                            fontSize: 2.5 * SizeConfig.text!,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(thickness: 2),
                h10,
                Text(
                  'Settings',
                  style: TextStyle(
                    color: black.withOpacity(0.7),
                    fontSize: 2.5 * SizeConfig.text!,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                h20,
                reminderButton(
                  name: 'Reminder',
                  imagePath: 'notification.PNG',
                  description: 'setup reminders to exercise.',
                  onTap: () {
                    Navigator.of(context).pushNamed('/RemindersPage');
                  },
                ),
                h10,
                reminderButton(
                  name: 'Reset',
                  imagePath: 'reset.png',
                  description: 'clear all user records in the app',
                  color: red,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AppDialog(
                            title: 'Reset',
                            subTitle:
                                'Are you sure you want to reset all data ?',
                            onContinue: () {
                              setState(() {
                                ExerciseDatabase.instance.resetUser();
                                ExerciseDatabase.instance.restAllData();
                                getUser();
                              });

                              Navigator.pop(context);
                            },
                          );
                        });
                    // getUser();
                  },
                ),
                h20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reminderButton({
    required String name,
    required Function() onTap,
    required String imagePath,
    Color? color,
    String? description = '',
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 4.5 * SizeConfig.height!,
            width: 4.5 * SizeConfig.height!,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.2 * SizeConfig.height!),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[color ?? blue, darkBlue],
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
              child: Image.asset(
                'assets/icons/$imagePath',
                color: white,
                height: 3.5 * SizeConfig.height!,
              ),
            ),
          ),
          w20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: black.withOpacity(0.7),
                  fontSize: 2.2 * SizeConfig.text!,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description!,
                style: TextStyle(
                  color: black.withOpacity(0.3),
                  fontSize: 1.6 * SizeConfig.text!,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget colorTag({
    required Color color,
    required double width,
    required String value,
    String? value2,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 5 * SizeConfig.height!,
            color: color,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: grey,
                  fontSize: 1.5 * SizeConfig.text!,
                  fontWeight: FontWeight.w900,
                ),
              ),
              value2 != null
                  ? Text(
                      value2,
                      style: TextStyle(
                        color: grey,
                        fontSize: 1.5 * SizeConfig.text!,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }

  Container settingsTile(
      String name, String imagePath, String value, Function() onTap) {
    return Container(
      height: 5.2 * SizeConfig.height!,
      padding: EdgeInsets.only(right: 4 * SizeConfig.width!),
      margin: EdgeInsets.only(bottom: 0.5 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/$imagePath.png',
                color: grey,
                height: 3.4 * SizeConfig.height!,
              ),
              w10,
              Text(
                name,
                style: TextStyle(
                  color: grey,
                  letterSpacing: 0.2,
                  fontSize: 2 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          value != '0.0'
              ? GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: blue,
                      letterSpacing: 0.3,
                      fontSize: 2 * SizeConfig.text!,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onTap,
                  child: Image.asset(
                    'assets/icons/add.png',
                    color: grey,
                    height: 3.5 * SizeConfig.height!,
                  ),
                ),
        ],
      ),
    );
  }
}
