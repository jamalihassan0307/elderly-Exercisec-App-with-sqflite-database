import 'package:flutter/material.dart';
import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/route.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/pages/splash_page.dart';

class ExerciseApp extends StatelessWidget {
  const ExerciseApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, layout) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(layout, orientation);
            return MaterialApp(
              title: 'Exercise App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: white,
                fontFamily: 'Gilroy',
              ),
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
}
