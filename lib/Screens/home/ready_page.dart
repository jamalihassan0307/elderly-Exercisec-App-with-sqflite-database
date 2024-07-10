import 'dart:async';
import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/route.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/database/app_db.dart';
import 'package:ex_app/data/model/event.dart';
import 'package:ex_app/data/model/report.dart';
import 'package:ex_app/pages/home/widgets/workout_timer.dart';
import 'package:ex_app/pages/home/widgets/reset_timer.dart';
import 'package:ex_app/pages/home/widgets/total_timer.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/dialog_box.dart';
import 'package:flutter/material.dart';

class ReadyPage extends StatefulWidget {
  final WorkoutArguments w;
  // final Levels level;
  // final int duration;
  const ReadyPage({Key? key, required this.w}) : super(key: key);

  @override
  State<ReadyPage> createState() => _ReadyPageState();
}

class _ReadyPageState extends State<ReadyPage> with TickerProviderStateMixin {
  late RestTimer restTimer = RestTimer(this);
  late TotalTimer totalTimer = TotalTimer(this);
  late WorkOutTimer workoutTimer = WorkOutTimer(this);

  PageController controller = PageController();
  int selectIndex = 0;
  late int count;
  bool isPlay = false;
  bool isPause = false;
  bool isDone = false;
  bool workOutStart = false;
  bool isSkip = false;
  bool isSecondRound = false;
  int skipTotTime = 0;
  double totCalerios = 0.0;
  @override
  void initState() {
    setState(() {
      count = widget.w.duration;
    });
    super.initState();
  }

  // void timecount() {
  //   const oneSec = Duration(seconds: 1);
  //   Timer.periodic(oneSec, (timer) {
  //     if (count == 0) {
  //       if (mounted) {
  //         setState(() {
  //           timer.cancel();
  //           isDone = true;
  //         });
  //         restTimer.restart();
  //       }
  //     } else {
  //       setState(() => count--);
  //     }
  //   });
  // }

  void pauseAndRePlay() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      // if (count == 0) {
      if (mounted) {
        setState(() {
          count--;
          timer.cancel();
        });
        restTimer.restart();
        workoutTimer.start();
        totalTimer.start();
      }
      // } else {
      //   setState(() => count--);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 50,
        leading: CustomCircleButton(
          onTap: () {
            Navigator.pop(context);
          },
          imagePath: 'back.png',
        ),
        title: Text(
          widget.w.level.title,
          style: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 2.5 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isPlay) {
                setState(() {
                  isPause = true;
                  isPlay = false;
                  isDone = false;
                  restTimer.pause();
                });
              }

              Navigator.of(context).pushNamed(
                '/ExerciseDetailsPage',
                arguments: widget.w.level.exercise[selectIndex],
              );
            },
            icon: const Icon(
              Icons.menu,
              color: blue,
            ),
          )
        ],
      ),
      body: PageView.builder(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          if (!isSkip) {
            skipTotTime = skipTotTime + 60;
            totCalerios = (widget.w.level.skipKcal * skipTotTime);
          }
        },
        itemBuilder: (context, position) {
          selectIndex = position;
          return Stack(
            children: [
              Column(
                children: [
                  h30,
                  Text(
                    widget.w.level.exercise[position].name,
                    style: TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 3 * SizeConfig.text!,
                      letterSpacing: 0.7,
                    ),
                  ),
                  h10,
                  Text(
                    position < 9 && widget.w.level.exercise.length < 9
                        ? '0${position + 1} of 0${widget.w.level.exercise.length}'
                        : '${position + 1} of ${widget.w.level.exercise.length}',
                    style: TextStyle(
                      color: darkBlue.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                      fontSize: 3.5 * SizeConfig.text!,
                    ),
                  ),
                  h20,
                  Expanded(
                    child: Stack(
                      children: [
                        Image.asset(
                          widget.w.level.exercise[position].imagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: isPause == true || count != 0
                              ? white.withOpacity(0.5)
                              : Colors.transparent,
                        )
                      ],
                    ),
                  )
                ],
              ),
              if (isPause == true || count != 0)
                // ? count == 4
                // ? const SizedBox()
                Center(
                  child: Text(
                    'Get Ready',
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                      fontSize: 8 * SizeConfig.text!,
                    ),
                  ),
                )
              // : count == 0
              //     ? const SizedBox()
              //     : Center(
              //         child: Text(
              //           count.toString(),
              //           style: TextStyle(
              //             color: blue,
              //             fontWeight: FontWeight.bold,
              //             letterSpacing: 0.7,
              //             fontSize: 8 * SizeConfig.text!,
              //           ),
              //         ),
              //       ),
              // : const SizedBox(),
              ,
              isPause
                  ? Center(
                      child: Text(
                        'Pause',
                        style: TextStyle(
                          color: red,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                          fontSize: 8 * SizeConfig.text!,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
        itemCount: widget.w.level.exercise.length, // Can be null
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          color: white,
          height: 25 * SizeConfig.height!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              controlBtn(
                image: isPause ? 'stop' : 'pause',
                onTap: () {
                  if (isPause) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AppDialog(
                            title: 'End Workout',
                            subTitle:
                                "Are you sure you want to End current Workout session?",
                            onContinue: () {
                              Navigator.of(context).pushNamed(
                                '/ViewAllExercisePage',
                                arguments: widget.w.level,
                              );
                            },
                          );
                        });
                  }
                  if (isPlay) {
                    setState(() {
                      isPause = true;
                      isPlay = false;
                      isDone = false;
                      restTimer.pause();
                    });
                  }
                },
              ),
              MaterialButton(
                splashColor: white,
                highlightColor: white,
                onPressed: () {
                  setState(() {
                    count = widget.w.duration;
                    isSkip = false;
                    isPlay = true;
                    isPause = false;
                  });
                  // timecount();
                  pauseAndRePlay();
                },
                child: isPlay
                    ? Container(
                        height: 19 * SizeConfig.height!,
                        width: 19 * SizeConfig.height!,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: blueShadow.withOpacity(0.6),
                              offset: const Offset(0, 10),
                              blurRadius: 20.0,
                            )
                          ],
                          color: white,
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.height!),
                        child: workOutStart
                            ? CustomWorkOutTimer(
                                child: SizedBox(
                                  height: 10 * SizeConfig.height!,
                                  width: 10 * SizeConfig.height!,
                                  //This is a small circle
                                  child: smallcircletimer(),
                                ),
                                controller: workoutTimer,
                                duration: widget
                                    .w.level.exercise[selectIndex].duration,
                                timerStyle: WOTimerStyle.ring,
                                onStart: totalTimer.start,
                                onEnd: handleTimerOnEnd3,
                                backgroundColor: blue.withOpacity(0.2),
                                progressIndicatorColor: red.withOpacity(0.8),
                                progressIndicatorDirection:
                                    WOTimerProgressIndicatorDirection
                                        .counterClockwise,
                                progressTextCountDirection:
                                    WOTimerProgressTextCountDirection
                                        .singleCount,
                                progressTextStyle:
                                    const TextStyle(color: blue, fontSize: 45),
                                strokeWidth: 8,
                              )
                            : CustomTimer(
                                duration: Duration(seconds: widget.w.duration),
                                child: SizedBox(
                                  height: 10 * SizeConfig.height!,
                                  width: 10 * SizeConfig.height!,
                                  //This is a small circle
                                  child: smallcircletimer(),
                                ),
                                controller: restTimer,
                                timerStyle: TimerStyle.ring,
                                onStart: handleTimerOnStart,
                                onEnd: handleTimerOnEnd,
                                backgroundColor: blue.withOpacity(0.3),
                                progressIndicatorColor: darkBlue,
                                progressIndicatorDirection:
                                    TimerProgressIndicatorDirection.clockwise,
                                progressTextCountDirection:
                                    TimerProgressTextCountDirection.singleCount,
                                progressTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                ),
                                strokeWidth: 8,
                              ),
                      )
                    : Container(
                        height: 15 * SizeConfig.height!,
                        width: 15 * SizeConfig.height!,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: blueShadow.withOpacity(0.6),
                              offset: const Offset(0, 10),
                              blurRadius: 20.0,
                            )
                          ],
                          color: white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: blue.withOpacity(0.6), width: 1.2),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/play.png',
                            scale: 0.5,
                            color: darkBlue,
                            height: 8 * SizeConfig.height!,
                          ),
                        ),
                      ),
              ),
              controlBtn(
                image: 'fast_forward',
                onTap: () {
                  if (workoutTimer.duration != null) {
                    skipButton();
                  }

                  setState(() {
                    controller.jumpToPage(selectIndex + 1);
                    isPlay = false;
                    workOutStart = false;
                    isPause = false;
                  });
                  if (selectIndex == widget.w.level.exercise.length - 1) {
                    saveDataTodatabase();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector controlBtn(
      {required String? image, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 8 * SizeConfig.height!,
        width: 8 * SizeConfig.height!,
        decoration: BoxDecoration(
          color: white,
          shape: BoxShape.circle,
          border: Border.all(color: blue.withOpacity(0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: blueShadow.withOpacity(0.6),
              offset: const Offset(0, 10),
              blurRadius: 20.0,
            )
          ],
        ),
        child: Image.asset(
          'assets/icons/$image.png',
          color: darkBlue,
          height: 3 * SizeConfig.height!,
        ),
      ),
    );
  }

  CustomResetTimer smallcircletimer() {
    return CustomResetTimer(
      duration: widget.w.level.duration,
      controller: totalTimer,
      timerStyle: RTimerStyle.ring,
      onStart: workoutTimer.restart,
      onEnd: handleTimerOnEnd2,
      backgroundColor: blueShadow.withOpacity(0.2),
      progressIndicatorColor: blue,
      progressIndicatorDirection: RTimerProgressIndicatorDirection.clockwise,
      progressTextCountDirection: RTimerProgressTextCountDirection.countDown,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
      strokeWidth: 5,
    );
  }

  void handleTimerOnStart() {
    // const oneSec = Duration(seconds: 1);

    // Timer.periodic(oneSec, (timer) {
    setState(() {
      count = widget.w.duration;
      // count--;
      // });
    });
  }

  void handleTimerOnStart3() {
    totalTimer.start();
  }

  void handleTimerOnEnd() {
    setState(() {
      workOutStart = true;
      count = 0;
    });

    timerStarter();
  }

  void timerStarter() {
    totalTimer.start();
    if (isSecondRound) {
      workoutTimer.restart();
    } else {
      setState(() => isSecondRound = true);
    }
  }

  void handleTimerOnEnd2() {
    restTimer.stop();
    totalTimer.stop();
    workoutTimer.stop();
    saveDataTodatabase();
  }

  void skipButton() {
    Duration wDurationValue = workoutTimer.duration! * workoutTimer.value;
    var workOutDuration = wDurationValue.inSeconds % 60;

    skipTotTime = skipTotTime + workOutDuration;
    totCalerios = (widget.w.level.skipKcal * skipTotTime);

    setState(() {
      isSkip = true;
      restTimer.stop();
      workoutTimer.stop();
      workoutTimer.reset();
    });
  }

  void handleTimerOnEnd3() {
    setState(() {
      totalTimer.pause();
      workOutStart = false;
      controller.jumpToPage(selectIndex + 1);
      restTimer.restart();
      workoutTimer.stop();
    });
    if (selectIndex == widget.w.level.exercise.length - 1) {
      restTimer.stop();
      totalTimer.stop();
      workoutTimer.stop();
      if (!isSkip) {
        // Duration wDurationValue =
        //     workoutTimer.duration! * workoutTimer.value;
        // var workOutDuration = wDurationValue.inSeconds % 60;
        // skipTotTime = skipTotTime + workOutDuration;
        skipTotTime = skipTotTime + 60;
        totCalerios = (widget.w.level.skipKcal * skipTotTime);
      }

      saveDataTodatabase();
    }
  }

  void saveDataTodatabase() {
    var now = DateTime.now();
    var data = Reports(
        kcal: totCalerios.toStringAsFixed(1),
        duration: skipTotTime.toString(),
        workouts: widget.w.level.exercise.length.toString(),
        time: now,
        eventKey: '${now.year}${now.month}${now.day}');
    var event = Event(
      eventKey: '${now.year}${now.month}${now.day}',
      kcal: totCalerios.toStringAsFixed(1),
      duration: skipTotTime.toString(),
      title: widget.w.level.title,
      dateTime: now,
    );
    ExerciseDatabase.instance.insertReport(data);
    ExerciseDatabase.instance.insertEvents(event);
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/CompletePage',
      (route) => false,
      arguments: CompletPageArguments(widget.w.level, event),
    );
  }

  @override
  void dispose() {
    restTimer.stop();
    totalTimer.stop();
    workoutTimer.stop();
    super.dispose();
  }
}
