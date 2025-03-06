import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/exercise_model.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:flutter/material.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailsPage({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 45 * SizeConfig.height!,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1A237E),
      leading: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.all(SizeConfig.height! * 0.2),
          child: CustomCircleButton(
            onTap: () => Navigator.pop(context),
            imagePath: 'back.png',
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          exercise.name,
          style: TextStyle(
            color: white,
            fontSize: 2.5 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'exercise_image_${exercise.name}',
              child: Image.asset(
                exercise.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('How to Perform'),
          h20,
          ...List.generate(
            exercise.steps.length,
            (index) => _buildStepItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.width!,
        vertical: SizeConfig.height!,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF1A237E),
          fontSize: 2.4 * SizeConfig.text!,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStepItem(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeConfig.height!),
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(1.2 * SizeConfig.height!),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF303F9F), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: white,
                fontSize: 2.2 * SizeConfig.text!,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          w20,
          Expanded(
            child: Text(
              exercise.steps[index],
              style: TextStyle(
                color: const Color(0xFF1A237E).withOpacity(0.8),
                fontSize: 1.8 * SizeConfig.text!,
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
