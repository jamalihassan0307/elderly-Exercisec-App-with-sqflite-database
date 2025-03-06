import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/Var_data/model/alarm.dart';
import 'package:ex_app/main.dart';
import 'package:ex_app/Screens/profile/widgets/weekdays_picker.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @pragma('vm:entry-point')
  static Future<void> handleSnooze(int id) async {
    final snoozeTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    await scheduleNotification(
      id,
      snoozeTime,
      isSnooze: true,
    );
  }

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<Alarm> arlams = [];
  // List repeat = [];
  List<RepateAlarm> weekShort = [];
  late DateTime alarmTime;
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    alarmTime = DateTime.now();
    refreshNotes();
    // Update the UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    arlams = await ExerciseDatabase.instance.showAll();

    setState(() => isLoading = false);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 6.2 * SizeConfig.height!,
        leading: CustomCircleButton(
          onTap: () {
            Navigator.pop(context);
          },
          imagePath: 'back.png',
        ),
        title: Text(
          'Reminders',
          style: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 2.9 * SizeConfig.text!,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: arlams.isNotEmpty
          ? CustomPicker(
              child: ListView(
                children: arlams.map<Widget>((remind) {
                  var time = DateFormat().add_jm().format(remind.remindTime);

                  return Container(
                    margin: EdgeInsets.all(2.3 * SizeConfig.height!),
                    padding: EdgeInsets.only(left: 3 * SizeConfig.width!, top: 1.5 * SizeConfig.height!),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(1.5 * SizeConfig.height!),
                      boxShadow: [
                        BoxShadow(
                          color: blueShadow.withOpacity(0.5),
                          offset: const Offset(1, 5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: black.withOpacity(0.7),
                                    fontSize: 3 * SizeConfig.text!,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  getRemainingTime(remind.remindTime),
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 2 * SizeConfig.text!,
                                  ),
                                ),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                activeColor: blue,
                                value: remind.isOn,
                                onChanged: (value) {
                                  setState(() {
                                    Alarm alarm = Alarm(
                                      id: remind.id,
                                      isOn: value,
                                      weekID: remind.weekID,
                                      remindTime: remind.remindTime,
                                    );
                                    ExerciseDatabase.instance.update(alarm);
                                  });
                                  refreshNotes();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repeat',
                                  style: TextStyle(
                                    color: black.withOpacity(0.4),
                                    fontSize: 2.2 * SizeConfig.text!,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.height!,
                                  width: 30 * SizeConfig.height!,
                                  child: FutureBuilder<List<RepateAlarm>>(
                                      future: ExerciseDatabase.instance.readArlam(remind.weekID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          weekShort = snapshot.data!;
                                          orderToWeekname();
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: weekShort.length,
                                            itemBuilder: (context, index) {
                                              var endItem = weekShort.length - 1;

                                              return Text(
                                                '${weekShort[index].week.substring(0, 3)}${endItem == index ? '' : ','}',
                                                style: TextStyle(
                                                  color: darkBlue.withOpacity(0.7),
                                                  fontSize: 1.8 * SizeConfig.text!,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      }),
                                ),
                                h5,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WeekDaysPicker(
                                            isUpdate: true,
                                            weekId: remind.weekID,
                                          );
                                        });
                                    refreshNotes();
                                  },
                                  child: Container(
                                    height: 5.3 * SizeConfig.height!,
                                    width: 6 * SizeConfig.height!,
                                    decoration: BoxDecoration(
                                      color: blue.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/edit.png',
                                        scale: 1.2,
                                        //height: 2.5 * SizeConfig.height!,
                                        color: darkBlue.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await ExerciseDatabase.instance.delete(remind.id!);
                                    refreshNotes();
                                  },
                                  child: Container(
                                    height: 5.3 * SizeConfig.height!,
                                    width: 6 * SizeConfig.height!,
                                    decoration: BoxDecoration(
                                      color: red.withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/delete.png',
                                        scale: 1.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/bell.png',
                    color: blue.withOpacity(0.5),
                    scale: 0.2,
                    height: 10 * SizeConfig.height!,
                  ),
                  h40,
                  Text(
                    'Please set your reminder',
                    style: TextStyle(
                      color: darkBlue.withOpacity(0.6),
                      fontSize: 3 * SizeConfig.text!,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () async {
          var selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (selectedTime != null) {
            final now = DateTime.now();
            var selectedDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            var weekID = now.toIso8601String();
            //  setState(() {
            alarmTime = selectedDateTime;
            // addAlarm(
            // );
            alarmOn(1, selectedDateTime);
            var insertArlam = Alarm(isOn: true, remindTime: alarmTime, weekID: weekID);
            //scheduleNotification(alarmTime, 0);
            ExerciseDatabase.instance.insertArlam(insertArlam);
            await showDialog(
                context: context,
                builder: (context) {
                  return WeekDaysPicker(
                    weekId: weekID,
                  );
                });
            refreshNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future alarmOn(int id, DateTime scheduledTime) async {
    // print('Here');
    DateTime scheduleAlarmDateTime;
    if (scheduledTime.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = scheduledTime;
    } else {
      scheduleAlarmDateTime = scheduledTime.add(const Duration(days: 1));
    }
    final alarmTime = tz.TZDateTime.parse(tz.local, scheduleAlarmDateTime.toIso8601String());
    // scheduleNotification();
    scheduleNotification(id, alarmTime);
  }

  void orderToWeekname() {
    weekShort.sort((a, b) => a.setOrder.compareTo(b.setOrder));
  }
}

Future<void> scheduleNotification(int id, tz.TZDateTime time, {bool isSnooze = false}) async {
  final androidChannel = AndroidNotificationDetails(
    'exercise_reminders',
    'Exercise Reminders',
    channelDescription: 'Reminders for exercise routines',
    importance: Importance.max,
    priority: Priority.high,
    sound: const RawResourceAndroidNotificationSound('ringtone'),
    playSound: true,
    enableVibration: true,
    fullScreenIntent: true,
    actions: <AndroidNotificationAction>[
      const AndroidNotificationAction(
        'snooze',
        'Snooze',
        showsUserInterface: true,
        cancelNotification: true,
      ),
      const AndroidNotificationAction(
        'dismiss',
        'Dismiss',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ],
    category: AndroidNotificationCategory.alarm,
    visibility: NotificationVisibility.public,
  );

  final notificationDetails = NotificationDetails(android: androidChannel);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    isSnooze ? 'Snoozed Exercise Reminder' : 'Exercise Time!',
    isSnooze ? 'Your exercise reminder was snoozed for 10 minutes' : 'Time for your workout routine',
    time,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    payload: 'exercise_reminder_$id',
  );
}

tz.TZDateTime _nextInstanceOfTenAM(tz.TZDateTime now) {
  tz.TZDateTime scheduledDate = tz.TZDateTime.local(now.year, now.month, now.day, now.hour, now.minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

String getRemainingTime(DateTime reminderTime) {
  final now = DateTime.now();
  final difference = reminderTime.difference(now);

  if (difference.isNegative) return 'Overdue';

  if (difference.inHours > 0) {
    return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m remaining';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m remaining';
  } else {
    return '${difference.inSeconds}s remaining';
  }
}
