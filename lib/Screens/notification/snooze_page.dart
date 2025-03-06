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
        backgroundColor: const Color(0xFF1A237E),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A237E),
                      const Color(0xFF303F9F),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeader(),
                      _buildAlarmContent(),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(3 * SizeConfig.height!),
      child: Text(
        'Exercise Reminder',
        style: TextStyle(
          color: Colors.white,
          fontSize: 3 * SizeConfig.text!,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildAlarmContent() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAlarmIcon(),
          SizedBox(height: 4 * SizeConfig.height!),
          _buildTimer(),
          SizedBox(height: 2 * SizeConfig.height!),
          Text(
            'Time to exercise!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 2.4 * SizeConfig.text!,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmIcon() {
    return Container(
      padding: EdgeInsets.all(4 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(3 * SizeConfig.height!),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.fitness_center_rounded,
          size: 12 * SizeConfig.height!,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Text(
      _timeDisplay,
      style: TextStyle(
        color: Colors.white,
        fontSize: 10 * SizeConfig.text!,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(4 * SizeConfig.height!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close_rounded,
            label: 'Dismiss',
            color: Colors.redAccent,
            onTap: _handleDismiss,
          ),
          _buildActionButton(
            icon: Icons.snooze_rounded,
            label: 'Snooze',
            color: Colors.white,
            onTap: _handleSnooze,
          ),
        ],
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
        width: 18 * SizeConfig.width!,
        padding: EdgeInsets.symmetric(
          vertical: 2 * SizeConfig.height!,
          horizontal: 2 * SizeConfig.width!,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(3 * SizeConfig.height!),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 4 * SizeConfig.height!,
            ),
            SizedBox(height: SizeConfig.height!),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 1.8 * SizeConfig.text!,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
