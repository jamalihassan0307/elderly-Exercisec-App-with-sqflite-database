import 'dart:async';
import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/route.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/Var_data/model/event.dart';
import 'package:ex_app/Var_data/model/report.dart';
import 'package:ex_app/Screens/home/widgets/workout_timer.dart';
import 'package:ex_app/Screens/home/widgets/reset_timer.dart';
import 'package:ex_app/Screens/home/widgets/total_timer.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
// import 'package:ex_app/widgets/dialog_box.dart';
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
  late RestTimer restTimer;
  late TotalTimer totalTimer;
  late WorkOutTimer workoutTimer;

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
    super.initState();
    restTimer = RestTimer(this);
    totalTimer = TotalTimer(this);
    workoutTimer = WorkOutTimer(
      this,
      duration: Duration(seconds: int.parse(widget.w.level.exercise[0].time)),
    );
    count = widget.w.duration;
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
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: PageView.builder(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _handlePageChange,
                itemBuilder: (context, position) {
                  selectIndex = position;
                  return _buildExerciseContent(position);
                },
              ),
            ),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.width!,
        vertical: 1 * SizeConfig.height!,
      ),
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomCircleButton(
            onTap: () => Navigator.pop(context),
            imagePath: 'back.png',
          ),
          Expanded(
            child: Text(
              widget.w.level.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF1A237E),
                fontSize: 2.5 * SizeConfig.text!,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _showExerciseDetails,
            icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF1A237E)),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(int position) {
    return Column(
      children: [
        _buildExerciseHeader(position),
        Expanded(
          child: _buildExerciseImage(position),
        ),
      ],
    );
  }

  Widget _buildExerciseHeader(int position) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isPause || count != 0 ? 0.5 : 1.0,
      child: Padding(
        padding: EdgeInsets.all(2 * SizeConfig.height!),
        child: Column(
          children: [
            Text(
              widget.w.level.exercise[position].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
                fontSize: 3 * SizeConfig.text!,
                letterSpacing: 0.7,
              ),
            ),
            h10,
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 2 * SizeConfig.width!,
                vertical: SizeConfig.height!,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                position < 9 && widget.w.level.exercise.length < 9
                    ? '0${position + 1} of 0${widget.w.level.exercise.length}'
                    : '${position + 1} of ${widget.w.level.exercise.length}',
                style: TextStyle(
                  color: const Color(0xFF1A237E),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  fontSize: 2.5 * SizeConfig.text!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseImage(int position) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'exercise_${widget.w.level.exercise[position].name}',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.w.level.exercise[position].imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (isPause || count != 0)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Text(
                isPause ? 'PAUSED' : 'GET READY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8 * SizeConfig.text!,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.skip_previous_rounded,
            onTap: () => controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          _buildTimerButton(),
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            onTap: () => _handleSkipForward(),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildControlButton({required IconData icon, required Function() onTap}) {
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
        child: Icon(
          icon,
          color: darkBlue,
          size: 3 * SizeConfig.height!,
        ),
      ),
    );
  }

  Widget _buildTimerButton() {
    return MaterialButton(
      splashColor: white,
      highlightColor: white,
      onPressed: () {
        setState(() {
          count = widget.w.duration;
          isSkip = false;
          isPlay = true;
          isPause = false;
        });
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
              margin: EdgeInsets.symmetric(vertical: 1 * SizeConfig.height!),
              child: workOutStart
                  ? CustomWorkOutTimer(
                      child: SizedBox(
                        height: 10 * SizeConfig.height!,
                        width: 10 * SizeConfig.height!,
                        child: smallcircletimer(),
                      ),
                      controller: workoutTimer,
                      duration: widget.w.level.exercise[selectIndex].duration,
                      timerStyle: WOTimerStyle.ring,
                      onStart: totalTimer.start,
                      onEnd: handleTimerOnEnd3,
                      backgroundColor: blue.withOpacity(0.2),
                      progressIndicatorColor: red.withOpacity(0.8),
                      progressIndicatorDirection: WOTimerProgressIndicatorDirection.counterClockwise,
                      progressTextCountDirection: WOTimerProgressTextCountDirection.singleCount,
                      progressTextStyle: const TextStyle(color: blue, fontSize: 45),
                      strokeWidth: 8,
                    )
                  : CustomTimer(
                      duration: Duration(seconds: widget.w.duration),
                      child: SizedBox(
                        height: 10 * SizeConfig.height!,
                        width: 10 * SizeConfig.height!,
                        child: smallcircletimer(),
                      ),
                      controller: restTimer,
                      timerStyle: TimerStyle.ring,
                      onStart: handleTimerOnStart,
                      onEnd: handleTimerOnEnd,
                      backgroundColor: blue.withOpacity(0.3),
                      progressIndicatorColor: darkBlue,
                      progressIndicatorDirection: TimerProgressIndicatorDirection.clockwise,
                      progressTextCountDirection: TimerProgressTextCountDirection.singleCount,
                      progressTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                      strokeWidth: 8,
                    ),
            )
          : Image.asset(
              'assets/icons/play.png',
              scale: 0.5,
              color: darkBlue,
              height: 8 * SizeConfig.height!,
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
    setState(() {
      count = widget.w.duration;
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

  void _handlePageChange(int index) {
    if (!isSkip) {
      skipTotTime = skipTotTime + 60;
      totCalerios = (widget.w.level.skipKcal * skipTotTime);
    }
  }

  void _showExerciseDetails() {
    Navigator.of(context).pushNamed(
      '/ExerciseDetailsPage',
      arguments: widget.w.level.exercise[selectIndex],
    );
  }

  void _handleSkipForward() {
    if (workoutTimer.duration != null) {
      skipButton();
    }

    setState(() {
      controller.jumpToPage(selectIndex + 1);
      workOutStart = false;
      isPause = false;
    });
    if (selectIndex == widget.w.level.exercise.length - 1) {
      saveDataTodatabase();
    }
  }

  @override
  void dispose() {
    restTimer.stop();
    totalTimer.stop();
    workoutTimer.stop();
    super.dispose();
  }
}
