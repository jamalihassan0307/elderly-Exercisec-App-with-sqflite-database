import 'package:ex_app/const/route.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/Screens/report/history_calender.dart';
import 'package:ex_app/const/color.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomPicker(
          child: Padding(
            padding: EdgeInsets.all(2 * SizeConfig.height!),
            child: Column(
              children: [
                _buildMonthSelector(),
                SizedBox(height: 2 * SizeConfig.height!),
                Expanded(
                  child: _buildCalendarCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1A237E),
      leading: CustomCircleButton(
        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/BottomNavBar',
          (route) => false,
          arguments: ScreenArguments(1, true),
        ),
        imagePath: 'back.png',
      ),
      title: Text(
        'Workout History',
        style: TextStyle(
          color: white,
          fontSize: 2.8 * SizeConfig.text!,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(3 * SizeConfig.height!),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.width!,
        vertical: SizeConfig.height!,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF1A237E)),
            onPressed: () {},
          ),
          Text(
            'March 2024',
            style: TextStyle(
              color: const Color(0xFF1A237E),
              fontSize: 2.2 * SizeConfig.text!,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF1A237E)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const HistoryCalender(),
      ),
    );
  }
}
