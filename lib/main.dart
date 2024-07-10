import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ex_app/data/database/app_db.dart';
import 'package:ex_app/exercise_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// var database;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the notification and show the reference.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //   onSelectNotification: (String? payload) async {
    // if (payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
  // }
  );
// Open the notification and show the reference.
  ExerciseDatabase.instance;
  AndroidAlarmManager.initialize();
  await _configureLocalTimeZone();
  runApp(const ExerciseApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
