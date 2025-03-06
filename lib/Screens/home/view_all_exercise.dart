import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/route.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/level_model.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/custom_round_btn.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/material.dart';

class ViewAllExercise extends StatefulWidget {
  final Levels level;
  const ViewAllExercise({Key? key, required this.level}) : super(key: key);

  @override
  _ViewAllExerciseState createState() => _ViewAllExerciseState();
}

class _ViewAllExerciseState extends State<ViewAllExercise> with SingleTickerProviderStateMixin {
  int editSecond = 5;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPicker(
        child: Stack(
          children: [
            _buildHeaderImage(),
            _buildBackButton(),
            _buildContentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Hero(
      tag: 'exercise_${widget.level.id}',
      child: Container(
        height: MediaQuery.of(context).size.height / 2.8,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.level.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: CustomCircleButton(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/BottomNavBar',
            (route) => false,
            arguments: ScreenArguments(0, false),
          );
        },
        imagePath: 'back.png',
      ),
    );
  }

  Widget _buildContentCard() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4 * SizeConfig.height!),
              topRight: Radius.circular(4 * SizeConfig.height!),
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(2.5 * SizeConfig.height!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  h20,
                  _buildWorkoutStats(),
                  h30,
                  _buildRestSection(),
                  h30,
                  _buildExercisesList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(_animationController),
      child: Text(
        widget.level.title,
        style: TextStyle(
          color: const Color(0xFF1A237E),
          fontSize: 3.2 * SizeConfig.text!,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWorkoutStats() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE3F2FD),
            const Color(0xFFBBDEFB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: 'gas.png',
            value: '${widget.level.kcal}',
            label: 'Kcal',
            color: orange,
          ),
          _buildStatItem(
            icon: 'time.png',
            value: '${widget.level.time}',
            label: 'Minutes',
            color: blue,
          ),
          _buildStatItem(
            icon: 'workout.png',
            value: '${widget.level.exercise.length}',
            label: 'Exercises',
            color: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(1.2 * SizeConfig.height!),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/$icon',
            height: 2.8 * SizeConfig.height!,
            color: color,
          ),
        ),
        h10,
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1A237E),
            fontSize: 2.2 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: grey,
            fontSize: 1.6 * SizeConfig.text!,
          ),
        ),
      ],
    );
  }

  Widget _buildRestSection() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rest between exercises',
            style: TextStyle(
              color: const Color(0xFF1A237E),
              fontSize: 2.1 * SizeConfig.text!,
              fontWeight: FontWeight.bold,
            ),
          ),
          h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeSelector(),
              CustomRoundBtn(
                onTap: () {
                  final w = WorkoutArguments(editSecond, widget.level);
                  Navigator.of(context).pushNamed(
                    '/ReadyPage',
                    arguments: w,
                  );
                },
                text: 'Start Workout',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Row(
      children: [
        Column(
          children: [
            Text(
              editSecond.toString(),
              style: TextStyle(
                color: const Color(0xFF1A237E),
                fontSize: 5 * SizeConfig.text!,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'seconds',
              style: TextStyle(
                color: grey,
                fontSize: 1.8 * SizeConfig.text!,
              ),
            ),
          ],
        ),
        w10,
        Column(
          children: [
            _buildTimeButton(
              onTap: () {
                if (50 > editSecond) setState(() => editSecond += 5);
              },
              icon: Icons.keyboard_arrow_up_rounded,
            ),
            h10,
            _buildTimeButton(
              onTap: () {
                if (5 < editSecond) setState(() => editSecond -= 5);
              },
              icon: Icons.keyboard_arrow_down_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 3.5 * SizeConfig.height!,
        width: 3.5 * SizeConfig.height!,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF303F9F),
              const Color(0xFF1A237E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, color: white),
      ),
    );
  }

  Widget _buildExercisesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.level.exercise.length,
      itemBuilder: (context, index) {
        final exercise = widget.level.exercise[index];
        // Calculate start and end times for staggered animation
        final double startTime = 0.2 + (index * 0.1).clamp(0.0, 0.6);
        final double endTime = startTime + 0.1;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                startTime, // Ensure start time is between 0.0 and 0.8
                endTime, // Ensure end time is between 0.1 and 0.9
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: _buildExerciseItem(exercise),
        );
      },
    );
  }

  Widget _buildExerciseItem(dynamic exercise) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
          onTap: () => Navigator.of(context).pushNamed(
            '/ExerciseDetailsPage',
            arguments: exercise,
          ),
          child: Padding(
            padding: EdgeInsets.all(1.5 * SizeConfig.height!),
            child: Row(
              children: [
                Hero(
                  tag: 'exercise_image_${exercise.name}',
                  child: Container(
                    height: 7 * SizeConfig.height!,
                    width: 7 * SizeConfig.height!,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.5 * SizeConfig.height!),
                      image: DecorationImage(
                        image: AssetImage(exercise.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                w20,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          color: const Color(0xFF1A237E),
                          fontSize: 2.2 * SizeConfig.text!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      h5,
                      Text(
                        '${exercise.time} seconds',
                        style: TextStyle(
                          color: grey,
                          fontSize: 1.8 * SizeConfig.text!,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: grey,
                  size: 2 * SizeConfig.height!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
