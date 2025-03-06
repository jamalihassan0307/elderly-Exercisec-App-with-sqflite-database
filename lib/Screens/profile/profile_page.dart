import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/Var_data/model/user.dart';
import 'package:ex_app/Screens/profile/widgets/dob_picker.dart';
import 'package:ex_app/Screens/profile/widgets/gender_picker.dart';
import 'package:ex_app/Screens/profile/widgets/height_picker.dart';
import 'package:ex_app/Screens/profile/widgets/name_picker.dart';
import 'package:ex_app/Screens/profile/widgets/weight_picker.dart';
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
      appBar: _buildAppBar(),
      body: CustomPicker(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(2 * SizeConfig.height!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                h20,
                _buildBMICard(),
                h30,
                _buildSettingsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1A237E),
      title: Text(
        'My Profile',
        style: TextStyle(
          color: white,
          fontSize: 2.8 * SizeConfig.text!,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(3 * SizeConfig.height!),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileItem('Name', userName, 'name'),
          _buildProfileItem('Gender', userGender, 'gender'),
          _buildProfileItem('Height', '$userHeight cm', 'height'),
          _buildProfileItem('Weight', '$userweight kg', 'weight'),
          _buildProfileItem('Date of birth', userDob, 'birthday'),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, String icon) {
    return GestureDetector(
      onTap: () => _handleEdit(label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.height!),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.2 * SizeConfig.height!),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/icons/$icon.png',
                color: const Color(0xFF1A237E),
                height: 2.5 * SizeConfig.height!,
              ),
            ),
            w20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFF1A237E).withOpacity(0.6),
                      fontSize: 1.6 * SizeConfig.text!,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Not set' : value,
                    style: TextStyle(
                      color: const Color(0xFF1A237E),
                      fontSize: 2 * SizeConfig.text!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: const Color(0xFF1A237E),
                size: 2.2 * SizeConfig.height!,
              ),
              onPressed: () => _handleEdit(label.toLowerCase()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMICard() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BMI Status',
            style: TextStyle(
              color: const Color(0xFF1A237E),
              fontSize: 2.2 * SizeConfig.text!,
              fontWeight: FontWeight.bold,
            ),
          ),
          h20,
          _buildBMIIndicator(),
          h10,
          Center(
            child: Text(
              bmiData,
                  style: TextStyle(
                color: const Color(0xFF1A237E),
                fontSize: 2 * SizeConfig.text!,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: const Color(0xFF1A237E),
            fontSize: 2.2 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
        h20,
        _buildSettingTile(
          'Reminders',
          'notification.PNG',
          'Setup reminders to exercise',
          () => Navigator.of(context).pushNamed('/RemindersPage'),
                ),
                h10,
        _buildSettingTile(
          'Reset Data',
          'reset.png',
          'Clear all user records',
          _handleReset,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildBMIIndicator() {
    return SizedBox(
                  height: 20 * SizeConfig.height!,
                  child: Stack(
                    children: [
                      Container(
                        height: 10 * SizeConfig.height!,
                        margin: EdgeInsets.only(top: 2.5 * SizeConfig.height!),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
                        child: Row(
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
                  colorTag(color: const Color(0xFFEA4450), width: 16 * SizeConfig.width!, value: '35', value2: '40'),
                ],
              ),
                        ),
                      ),
                      bmiValue != 0.0
                          ? Positioned(
                              top: 0,
                              left: level > 37 ? level - 4 * SizeConfig.width! : level,
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
        ],
      ),
    );
  }

  Widget _buildSettingTile(String name, String imagePath, String description, Function() onTap, {Color? color}) {
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
                description,
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

  void _handleEdit(String label) {
    switch (label.toLowerCase()) {
      case 'name':
        showDialog(
          context: context,
          builder: (_) => NamePicker(
            getName: (name) => setState(() {
              userName = name;
              ExerciseDatabase.instance.updateUser('name', name);
              getUser();
            }),
            name: userName,
          ),
        );
        break;

      case 'gender':
        showDialog(
          context: context,
          builder: (_) => GenderPicker(
            gender: (gender) => setState(() {
              userGender = gender;
              ExerciseDatabase.instance.updateUser('gender', gender);
              getUser();
            }),
          ),
        );
        break;

      case 'height':
        showDialog(
          context: context,
          builder: (_) => HeightPicker(
            height: (height) => setState(() {
              userHeight = height;
              ExerciseDatabase.instance.updateUser('height', height);
              getUser();
            }),
            initialValue: userHeight,
          ),
        );
        break;

      case 'weight':
        showDialog(
          context: context,
          builder: (_) => WeightPicker(
            weight: (weight) => setState(() {
              userweight = weight;
              ExerciseDatabase.instance.updateUser('weight', weight);
              getUser();
            }),
          ),
        );
        break;

      case 'date of birth':
        showDialog(
          context: context,
          builder: (_) => DOBPicker(
            dob: (dob) => setState(() {
              userDob = dob;
              ExerciseDatabase.instance.updateUser('birth', dob);
              getUser();
            }),
          ),
        );
        break;
    }
  }

  void _handleReset() {
    showDialog(
        context: context,
        builder: (builder) {
          return AppDialog(
            title: 'Reset',
            subTitle: 'Are you sure you want to reset all data ?',
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
}
