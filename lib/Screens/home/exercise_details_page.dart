import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/exercise_model.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:flutter/material.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailsPage({Key? key, required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          exercise.name,
          style: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 3.2 * SizeConfig.text!,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 6.5 * SizeConfig.height!,
        leading: CustomCircleButton(
          onTap: () {
            Navigator.pop(context);
          },
          imagePath: 'back.png',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.height!),
          child: ListView(
            children: [
              Image.asset(
                exercise.imagePath,
                height: 40 * SizeConfig.height!,
                fit: BoxFit.fill,
              ),
              h20,
              for (int i = 0; exercise.steps.length > i; i++)
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 2 * SizeConfig.height!,
                    horizontal: 1 * SizeConfig.height!,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 2.5 * SizeConfig.height!,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: white,
                            fontSize: 2.6 * SizeConfig.text!,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: blue,
                      ),
                      w20,
                      Container(
                        width: 35 * SizeConfig.height!,
                        color: white,
                        child: Text(
                          exercise.steps[i],
                          style: TextStyle(
                            color: black.withOpacity(0.6),
                            letterSpacing: 1,
                            fontSize: 2 * SizeConfig.text!,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
