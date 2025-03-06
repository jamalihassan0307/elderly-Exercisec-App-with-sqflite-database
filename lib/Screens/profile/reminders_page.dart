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
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomPicker(
          child: arlams.isNotEmpty ? _buildRemindersList() : _buildEmptyState(),
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1A237E),
      leading: CustomCircleButton(
        onTap: () => Navigator.pop(context),
        imagePath: 'back.png',
      ),
      title: Text(
        'Reminders',
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

  Widget _buildRemindersList() {
    return ListView.builder(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      itemCount: arlams.length,
      itemBuilder: (context, index) {
        final remind = arlams[index];
        final time = DateFormat().add_jm().format(remind.remindTime);

        return Container(
          margin: EdgeInsets.only(bottom: 2 * SizeConfig.height!),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A237E).withOpacity(0.08),
                offset: const Offset(0, 4),
                blurRadius: 15,
              )
            ],
          ),
          child: Column(
            children: [
              _buildReminderHeader(remind, time),
              _buildReminderDetails(remind),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderHeader(Alarm remind, String time) {
    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: const Color(0xFF1A237E),
                  fontSize: 3.2 * SizeConfig.text!,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getRemainingTime(remind.remindTime),
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 1.8 * SizeConfig.text!,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: remind.isOn,
              onChanged: (value) => _updateAlarmState(remind, value),
              activeColor: const Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderDetails(Alarm remind) {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repeat',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 1.8 * SizeConfig.text!,
                  ),
                ),
                h5,
                _buildWeekDaysList(remind),
              ],
            ),
          ),
          _buildActionButtons(remind),
        ],
      ),
    );
  }

  Widget _buildWeekDaysList(Alarm remind) {
    return SizedBox(
      height: 2.2 * SizeConfig.height!,
      child: FutureBuilder<List<RepateAlarm>>(
        future: ExerciseDatabase.instance.readArlam(remind.weekID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          weekShort = snapshot.data!;
          orderToWeekname();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: weekShort.length,
            separatorBuilder: (_, __) => Text(', '),
            itemBuilder: (context, index) {
              return Text(
                weekShort[index].week.substring(0, 3),
                style: TextStyle(
                  color: const Color(0xFF1A237E),
                  fontSize: 1.8 * SizeConfig.text!,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(Alarm remind) {
    return Row(
      children: [
        _buildIconButton(
          onTap: () => _editReminder(remind),
          icon: Icons.edit_rounded,
          color: const Color(0xFF1A237E),
        ),
        w10,
        _buildIconButton(
          onTap: () => _deleteReminder(remind),
          icon: Icons.delete_rounded,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.height!),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 2.2 * SizeConfig.height!),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
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

  void _updateAlarmState(Alarm remind, bool value) {
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
  }

  void _editReminder(Alarm remind) async {
    await showDialog(
        context: context,
        builder: (context) {
          return WeekDaysPicker(
            isUpdate: true,
            weekId: remind.weekID,
          );
        });
    refreshNotes();
  }

  void _deleteReminder(Alarm remind) async {
    await ExerciseDatabase.instance.delete(remind.id!);
    refreshNotes();
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
