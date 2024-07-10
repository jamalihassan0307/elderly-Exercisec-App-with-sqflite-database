import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/route.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/level_model.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/custom_round_btn.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/material.dart';

class ViewAllExercise extends StatefulWidget {
  final Levels level;
  const ViewAllExercise({Key? key, required this.level}) : super(key: key);

  @override
  _ViewAllExerciseState createState() => _ViewAllExerciseState();
}

class _ViewAllExerciseState extends State<ViewAllExercise> {
  // late int editSecond, stableValue;
  int editSecond = 5;

  @override
  void initState() {
    // editSecond = stableValue = int.parse(widget.level.exercise[0].time);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: CustomPicker(
          child: Stack(
            children: [
              Container(
                height: height / 2.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.level.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              CustomCircleButton(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/BottomNavBar',
                    (route) => false,
                    arguments: ScreenArguments(0, false),
                  );
                },
                imagePath: 'back.png',
              ),
              Container(
                height: height,
                width: double.infinity,
                margin: EdgeInsets.only(top: height / 3.2),
                padding: EdgeInsets.symmetric(
                  vertical: 2.5 * SizeConfig.height!,
                  horizontal: 2.5 * SizeConfig.height!,
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4 * SizeConfig.height!),
                    topRight: Radius.circular(4 * SizeConfig.height!),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.level.title,
                      style: TextStyle(
                        color: black.withOpacity(0.7),
                        fontSize: 3 * SizeConfig.text!,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    h10,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/icons/gas.png',
                          height: 2.8 * SizeConfig.height!,
                          color: orange,
                        ),
                        w10,
                        Text(
                          '${widget.level.kcal} Kcal',
                          style: TextStyle(
                            color: grey,
                            fontSize: 2 * SizeConfig.text!,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        w20,
                        Image.asset(
                          'assets/icons/time.png',
                          height: 3 * SizeConfig.height!,
                          color: blue,
                        ),
                        w10,
                        Text(
                          '${widget.level.time} Min',
                          style: TextStyle(
                            color: grey,
                            fontSize: 2 * SizeConfig.text!,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    h10,
                    Text(
                      'Rest between exercises',
                      style: TextStyle(
                        color: black.withOpacity(0.7),
                        fontSize: 2.1 * SizeConfig.text!,
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    h20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  editSecond.toString(),
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 5 * SizeConfig.text!,
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'seconds',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 2 * SizeConfig.text!,
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            w10,
                            Column(
                              children: [
                                secondUpDownBtn(
                                    onTap: () {
                                      if (50 > editSecond) {
                                        setState(() => editSecond += 5);
                                      }
                                    },
                                    image: 'up.png'),
                                h10,
                                secondUpDownBtn(
                                    onTap: () {
                                      if (5 < editSecond) {
                                        setState(() => editSecond -= 5);
                                      }
                                    },
                                    image: 'down.png'),
                              ],
                            ),
                          ],
                        ),
                        CustomRoundBtn(
                          onTap: () {
                            final w =
                                WorkoutArguments(editSecond, widget.level);
                            Navigator.of(context).pushNamed(
                              '/ReadyPage',
                              arguments: w,
                            );
                          },
                          text: 'Start Workout',
                        )
                      ],
                    ),
                    h20,
                    Center(
                      child: Text(
                        '${widget.level.exercise.length} Exercises',
                        style: TextStyle(
                          color: black.withOpacity(0.7),
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.bold,
                          fontSize: 2.3 * SizeConfig.text!,
                        ),
                      ),
                    ),
                    h10,
                    const Divider(
                      thickness: 1,
                      color: darkBlue,
                    ),
                    h10,
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.level.exercise.length,
                        itemBuilder: (itemBuilder, index) {
                          final exer = widget.level.exercise[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/ExerciseDetailsPage',
                                arguments: exer,
                              );
                            },
                            child: Container(
                              height: 7.5 * SizeConfig.height!,
                              color: white,
                              margin: EdgeInsets.only(
                                  bottom: 1 * SizeConfig.height!),
                              child: Row(
                                children: [
                                  Container(
                                    height: 6 * SizeConfig.height!,
                                    width: 6 * SizeConfig.height!,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(exer.imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          1 * SizeConfig.height!),
                                      color: grey,
                                    ),
                                  ),
                                  w10,
                                  Text(
                                    '${exer.time}s',
                                    style: TextStyle(
                                      color: grey,
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 1.9 * SizeConfig.text!,
                                    ),
                                  ),
                                  w30,
                                  Text(
                                    '${exer.name}',
                                    style: TextStyle(
                                      color: black.withOpacity(0.7),
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 2.2 * SizeConfig.text!,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondUpDownBtn({required String image, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 3.5 * SizeConfig.height!,
        width: 3.5 * SizeConfig.height!,
        child: Center(
          child: Image.asset(
            'assets/icons/$image',
            color: white,
            height: 2 * SizeConfig.height!,
          ),
        ),
        decoration: BoxDecoration(
          color: blue,
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.3),
              offset: const Offset(1, 1),
              blurRadius: 20,
            ),
          ],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
