import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/level_model.dart';
import 'package:flutter/material.dart';

class MainExerciseTile extends StatelessWidget {
  final Levels level;
  const MainExerciseTile({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/ViewAllExercisePage',
          arguments: level,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 1.5 * SizeConfig.height!,
          right: 3 * SizeConfig.height!,
          bottom: 2.5 * SizeConfig.height!,
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: blue.withOpacity(0.2),
              offset: const Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25 * SizeConfig.height!,
              width: 32 * SizeConfig.height!,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: AssetImage(level.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            h10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                level.title,
                style: TextStyle(
                  color: black,
                  fontSize: 2.3 * SizeConfig.text!,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            h5,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "${level.time} min - ${level.kcal} kcal",
                style: TextStyle(
                  color: grey,
                  fontSize: 1.85 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
