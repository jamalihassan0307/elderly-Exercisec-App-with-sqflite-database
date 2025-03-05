// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('allstriking_logo');

    const initializationSettings = InitializationSettings(android: android);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String? payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    // }
    );
  }

  Future<void> scheduleNotification(DateTime dateTime, int id) async {
    // var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    const androidChannel = AndroidNotificationDetails(
      '0',
      'reminder',
      channelDescription: 'Exercise Reminder Notification',
      icon: 'logo',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
    );

    const channelSpecifics = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.show(
      id,
      'title',
      'body',
      channelSpecifics,
      payload: 'Test Payload',
    );
  }

  Future<void> zonedScheduleNotification(DateTime dateTime, int id) async {
    const androidChannel = AndroidNotificationDetails(
      '0',
      'reminder',
      channelDescription: 'Exercise Reminder Notification',
      icon: 'logo',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
    );

    const channelSpecifics = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Scheduled Notification',
      'This is the body of the notification',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
      channelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
