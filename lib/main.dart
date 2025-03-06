import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/exercise_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// var database;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the notification and show the reference.
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/logo');

  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    //   onSelectNotification: (String? payload) async {
    // if (payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // }
  );
// Open the notification and show the reference.
  ExerciseDatabase.instance;
  await AndroidAlarmManager.initialize();
  tz.initializeTimeZones();
  runApp(const ExerciseApp());
}
