import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/route.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/custom_round_btn.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatelessWidget {
  final CompletPageArguments arg;
  const CompletePage({Key? key, required this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = double.parse(arg.event.duration);
    final time = duration > 60 ? 'Minutes' : 'Seconds';
    final timeTo = duration > 60 ? (duration / 60).toStringAsFixed(1) : duration.toString();

    return Scaffold(
      body: Stack(
        children: [
          _buildHeaderImage(),
          _buildBackButton(context),
          _buildContentCard(context, timeTo, time),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 45 * SizeConfig.height!,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(arg.levels.imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: CustomCircleButton(
        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/ViewAllExercisePage',
          (route) => false,
          arguments: arg.levels,
        ),
        imagePath: 'back.png',
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, String timeTo, String time) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(4 * SizeConfig.height!),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(3 * SizeConfig.height!),
            child: Column(
              children: [
                _buildCongratulationsText(),
                h20,
                _buildTrophy(),
                h30,
                _buildStats(timeTo, time),
                h30,
                _buildCompleteButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCongratulationsText() {
    return Column(
      children: [
        Text(
          'Congratulations! 🎉',
          style: TextStyle(
            color: const Color(0xFF1A237E),
            fontSize: 3.5 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        h10,
        Text(
          'You\'ve completed your workout!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 2.2 * SizeConfig.text!,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTrophy() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.all(3 * SizeConfig.height!),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE3F2FD),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 20 * value,
                  spreadRadius: 10 * value,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/icons/trophy.PNG',
        height: 15 * SizeConfig.height!,
      ),
    );
  }

  Widget _buildStats(String timeTo, String time) {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            value: arg.event.kcal,
            label: 'Calories\nBurned',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
          ),
          Container(
            width: 1,
            height: 8 * SizeConfig.height!,
            color: Colors.grey.withOpacity(0.2),
          ),
          _buildStatItem(
            value: timeTo,
            label: time,
            icon: Icons.timer_rounded,
            color: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 4 * SizeConfig.height!),
          h10,
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 3 * SizeConfig.text!,
              fontWeight: FontWeight.bold,
            ),
          ),
          h5,
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 1.8 * SizeConfig.text!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton(BuildContext context) {
    return CustomRoundBtn(
      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
        '/BottomNavBar',
        (route) => false,
        arguments: ScreenArguments(0, false),
      ),
      text: 'Back to Home',
    );
  }
}
