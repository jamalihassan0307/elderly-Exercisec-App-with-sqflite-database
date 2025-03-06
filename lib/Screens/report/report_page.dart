import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/const/space.dart';
import 'package:ex_app/Var_data/database/app_db.dart';
import 'package:ex_app/Var_data/model/report.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with SingleTickerProviderStateMixin {
  List<Reports> reports = [];
  List<Reports> history = [];
  int totWorkout = 0;
  double totKacl = 0.0, totTime = 0.0;
  String timeTo = '';
  String time = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    showData();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future showData() async {
    reports = await ExerciseDatabase.instance.showReports();

    calculateData();
    if (mounted) setState(() {});
  }

  void calculateData() async {
    for (int i = 0; i < reports.length; i++) {
      totWorkout = totWorkout + int.parse(reports[i].workouts);
      totKacl = totKacl + double.parse(reports[i].kcal);
      totTime = totTime + double.parse(reports[i].duration);
      var date = '${reports[i].time.year}${reports[i].time.month}${reports[i].time.day}';

      history = await ExerciseDatabase.instance.showHistory(date);
    }

    setState(() {
      if (totTime > 60) {
        var min = totTime / 60;
        if (min > 60) {
          var hour = min / 60;
          timeTo = hour.toStringAsFixed(0);
          time = 'Hour';
        } else {
          timeTo = min.toStringAsFixed(0);
          time = 'Minutes';
        }
      } else {
        timeTo = totTime.toString();
        time = 'Seconds';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(2 * SizeConfig.height!),
              child: Column(
                children: [
                  _buildSummaryCard(),
                  h30,
                  _buildHistorySection(),
                  h20,
                  _buildWeeklyProgress(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1A237E),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Your Progress',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF303F9F),
                const Color(0xFF1A237E),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      )),
      child: Container(
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Summary',
                  style: TextStyle(
                    color: const Color(0xFF1A237E),
                    fontSize: 2.5 * SizeConfig.text!,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.insights_rounded,
                  color: const Color(0xFF1A237E),
                  size: 24,
                ),
              ],
            ),
            Divider(
              color: const Color(0xFF1A237E).withOpacity(0.2),
              thickness: 2,
            ),
            h20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: 'workout',
                  label: 'Workouts',
                  value: totWorkout.toString(),
                ),
                _buildStatItem(
                  icon: 'gas',
                  label: 'Kcal',
                  value: totKacl.toStringAsFixed(0),
                ),
                _buildStatItem(
                  icon: 'time',
                  label: 'Duration',
                  value: timeTo,
                  subtitle: time,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return FadeTransition(
      opacity: _animationController,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF303F9F).withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/icons/$icon.png',
              color: Colors.white,
              height: 3 * SizeConfig.height!,
            ),
          ),
          h10,
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF1A237E).withOpacity(0.7),
              fontSize: 1.8 * SizeConfig.text!,
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
          if (subtitle != null) ...[
            h5,
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFF1A237E).withOpacity(0.7),
                fontSize: 1.5 * SizeConfig.text!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Activity',
              style: TextStyle(
                color: const Color(0xFF1A237E),
                fontSize: 2.5 * SizeConfig.text!,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/HistoryPage'),
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF1A237E),
              ),
            ),
          ],
        ),
        h20,
        _buildWeeklyProgress(),
      ],
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      padding: EdgeInsets.all(2 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2 * SizeConfig.height!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 6; i >= 0; i--) _buildDayProgress(i),
        ],
      ),
    );
  }

  Widget _buildDayProgress(int index) {
    var now = DateTime.now();
    var day = now.subtract(Duration(days: index));
    var dayName = _getWeekName(day);
    bool isComplete = false;

    if (reports.isNotEmpty) {
      for (var report in reports) {
        if ('${day.month}${day.day}' == '${report.time.month}${report.time.day}') {
          isComplete = true;
          break;
        }
      }
    }

    return FadeTransition(
      opacity: _animationController,
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              color: const Color(0xFF1A237E).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          h10,
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              gradient: isComplete
                  ? const LinearGradient(
                      colors: [Color(0xFF303F9F), Color(0xFF1A237E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isComplete ? null : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A237E).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.done_rounded, color: Colors.white)
                  : Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: const Color(0xFF1A237E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekName(DateTime value) {
    var weekday = '';
    if (value.weekday == DateTime.monday) {
      weekday = 'Mon';
    } else if (value.weekday == DateTime.tuesday) {
      weekday = 'Tue';
    } else if (value.weekday == DateTime.wednesday) {
      weekday = 'Wed';
    } else if (value.weekday == DateTime.thursday) {
      weekday = 'Thu';
    } else if (value.weekday == DateTime.friday) {
      weekday = 'Fri';
    } else if (value.weekday == DateTime.saturday) {
      weekday = 'Sat';
    } else {
      weekday = 'Sun';
    }
    return weekday;
  }
}
