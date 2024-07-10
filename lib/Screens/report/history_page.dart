import 'package:ex_app/Core/route.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/pages/report/history_calender.dart';
import 'package:ex_app/Core/color.dart';
import 'package:ex_app/widgets/custom_circle_button.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leadingWidth: 6.2 * SizeConfig.height!,
        centerTitle: true,
        leading: CustomCircleButton(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/BottomNavBar',
              (route) => false,
              arguments: ScreenArguments(1, true),
            );
          },
          imagePath: 'back.png',
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 2.9 * SizeConfig.text!,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const CustomPicker(
        child: HistoryCalender(),
      ),
    );
  }
}
