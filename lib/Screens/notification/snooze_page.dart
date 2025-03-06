// ignore_for_file: use_super_parameters

import 'package:ex_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ex_app/const/color.dart';
import 'package:ex_app/Screens/profile/reminders_page.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ex_app/const/size/size_config.dart';

class SnoozePage extends StatefulWidget {
  final int notificationId;

  const SnoozePage({Key? key, required this.notificationId}) : super(key: key);

  @override
  State<SnoozePage> createState() => _SnoozePageState();
}

class _SnoozePageState extends State<SnoozePage> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 60;
  late AudioPlayer audioPlayer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSnoozeTimer();
    _startAlarmSound();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  Future<void> _startAlarmSound() async {
    audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('sound.mp3'));
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
          }
        });
      }
    });
  }

  void _handleSnooze() async {
    _timer?.cancel();
    audioPlayer.stop();
    await _animationController.reverse();
    await flutterLocalNotificationsPlugin.cancel(widget.notificationId);
    await RemindersPage.handleSnooze(widget.notificationId);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleDismiss() async {
    audioPlayer.stop();
    await _animationController.reverse();
    await flutterLocalNotificationsPlugin.cancel(widget.notificationId);
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.95),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: EdgeInsets.all(4 * SizeConfig.height!),
                        decoration: BoxDecoration(
                          color: blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.alarm,
                          size: 15 * SizeConfig.height!,
                          color: blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * SizeConfig.height!),
                    Text(
                      _timeDisplay,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8 * SizeConfig.text!,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5 * SizeConfig.height!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.close,
                          label: 'Dismiss',
                          color: Colors.red,
                          onTap: _handleDismiss,
                        ),
                        _buildActionButton(
                          icon: Icons.snooze,
                          label: 'Snooze',
                          color: blue,
                          onTap: _handleSnooze,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5 * SizeConfig.width!,
          vertical: 2 * SizeConfig.height!,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 4 * SizeConfig.height!),
            SizedBox(height: 1 * SizeConfig.height!),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 2 * SizeConfig.text!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
