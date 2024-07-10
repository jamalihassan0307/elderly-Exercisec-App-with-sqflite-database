import 'dart:async';

import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/route.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/BottomNavBar',
        (route) => false,
        arguments: ScreenArguments(0, false),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 22 * SizeConfig.height!,
          width: 22 * SizeConfig.height!,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[blue, darkBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: blueShadow,
                offset: Offset(0, 10),
                spreadRadius: 2,
                blurRadius: 20.0,
              )
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/Logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
