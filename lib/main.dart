import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/exercise_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:ex_app/Screens/profile/reminders_page.dart';
import 'package:ex_app/Screens/notification/snooze_page.dart';

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
      if (response.payload != null) {
        final id = int.tryParse(response.payload!.split('_').last) ?? 0;
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => SnoozePage(notificationId: id),
          ),
        );
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
  if (response.payload != null) {
    final id = int.tryParse(response.payload!.split('_').last) ?? 0;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => SnoozePage(notificationId: id),
      ),
    );
  }
}

// Handle snooze action
Future<void> _handleSnooze(int id) async {
  // Schedule new notification for 10 minutes later
  final snoozeTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
  print(snoozeTime);
  await scheduleNotification(id, snoozeTime);
}
