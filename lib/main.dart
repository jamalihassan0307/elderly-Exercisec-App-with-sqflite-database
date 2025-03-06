import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/exercise_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:ex_app/Screens/profile/reminders_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// var database;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle notification tap
      if (response.payload != null) {
        // Navigate to exercise page
        navigatorKey.currentState?.pushNamed('/ViewAllExercisePage');
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Handle notification actions
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        'exercise_reminders',
        'Exercise Reminders',
        description: 'Reminders for exercise routines',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ));

  ExerciseDatabase.instance;
  await AndroidAlarmManager.initialize();
  tz.initializeTimeZones();
  runApp(const ExerciseApp());
}

// Handle background notification taps
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  // Handle notification tap in background
  if (response.actionId == 'snooze') {
    // Get the notification ID from the payload
    final id = int.tryParse(response.payload?.split('_').last ?? '0') ?? 0;
    await RemindersPage.handleSnooze(id);
  } else if (response.actionId == 'dismiss') {
    final id = int.tryParse(response.payload?.split('_').last ?? '0') ?? 0;
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

// Handle snooze action
Future<void> _handleSnooze(int id) async {
  // Schedule new notification for 10 minutes later
  final snoozeTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));
  await scheduleNotification(id, snoozeTime);
}
