// ignore_for_file: use_super_parameters

import 'package:ex_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ex_app/const/color.dart';
import 'package:ex_app/Screens/profile/reminders_page.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class SnoozePage extends StatefulWidget {
  final int notificationId;

  const SnoozePage({Key? key, required this.notificationId}) : super(key: key);

  @override
  State<SnoozePage> createState() => _SnoozePageState();
}

class _SnoozePageState extends State<SnoozePage> {
  Timer? _timer;
  int _remainingSeconds = 60;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    _startSnoozeTimer();
    _startAlarmSound();
  }

  Future<void> _startAlarmSound() async {
    audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('sound.mp3'));
    // Loop the sound
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _startSnoozeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
            _handleSnooze();
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  void _handleSnooze() async {
    _timer?.cancel();
    audioPlayer.stop(); // Stop the sound
    await flutterLocalNotificationsPlugin.cancel(widget.notificationId);
    await RemindersPage.handleSnooze(widget.notificationId);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String get _timeDisplay {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _handleSnooze();
            } else if (details.primaryVelocity! < 0) {
              audioPlayer.stop(); // Stop the sound
              flutterLocalNotificationsPlugin.cancel(widget.notificationId);
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.alarm,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  _timeDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSwipeHint(
                      Icons.close,
                      'Swipe left to dismiss',
                      Colors.red,
                    ),
                    _buildSwipeHint(
                      Icons.snooze,
                      'Swipe right to snooze',
                      blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
