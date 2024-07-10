import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/level_model.dart';
import 'package:ex_app/pages/home/widgets/main_tile.dart';
import 'package:ex_app/pages/home/widgets/second_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(18 * SizeConfig.height!),
          child: Container(
            height: 10 * SizeConfig.height!,
            padding: EdgeInsets.only(
              top: 2 * SizeConfig.height!,
              right: 1.5 * SizeConfig.height!,
              bottom: 3 * SizeConfig.height!,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 2 * SizeConfig.text!,
                    letterSpacing: 1.1,
                    color: black.withOpacity(0.8),
                  ),
                ),
                Text(
                  "Don't Miss the Fitness!",
                  style: TextStyle(
                    fontSize: 2 * SizeConfig.text!,
                    letterSpacing: 1.1,
                    color: black.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: 1.5 * SizeConfig.height!,
            bottom: 3 * SizeConfig.height!,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercise',
                style: TextStyle(
                  fontSize: 2.7 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: black.withOpacity(0.8),
                ),
              ),
              h30,
              SizedBox(
                height: 37 * SizeConfig.height!,
                child: ListView.builder(
                    itemCount: levels.length - 1,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (itemBuilder, index) {
                      return MainExerciseTile(
                        level: levels[index],
                      );
                    }),
              ),
              h20,
              Text(
                'Extra Exercise',
                style: TextStyle(
                  fontSize: 2.7 * SizeConfig.text!,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: black.withOpacity(0.8),
                ),
              ),
              h30,
              ExtraExerciseTile(
                level: levels[levels.length - 1],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
