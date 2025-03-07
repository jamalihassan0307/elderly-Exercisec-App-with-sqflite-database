import 'package:ex_app/const/color.dart';
import 'package:ex_app/const/route.dart';
import 'package:ex_app/const/size/size_config.dart';
import 'package:ex_app/Var_data/nav_button_data.dart';
import 'package:ex_app/Screens/home/home_page.dart';
import 'package:ex_app/Screens/profile/profile_page.dart';
import 'package:ex_app/Screens/report/report_page.dart';
import 'package:ex_app/widgets/picker.dart';
import 'package:flutter/material.dart';
import 'package:ex_app/Screens/notification/snooze_page.dart';

class BottomNavBar extends StatefulWidget {
  final ScreenArguments newArgu;
  const BottomNavBar({Key? key, required this.newArgu}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController controller = PageController();

  int selectBtn = 0;
  bool isJump = false;
  @override
  void initState() {
    setState(() {
      selectBtn = widget.newArgu.index;
      isJump = widget.newArgu.isJump;
    });
    super.initState();
  }

  void _handleNotificationNavigation(int notificationId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SnoozePage(
          notificationId: notificationId,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPicker(
        child: PageView.builder(
          controller: controller,
          onPageChanged: (value) => setState(() {
            selectBtn = value;
          }),
          itemCount: bottomMenu.length,
          itemBuilder: (itemBuilder, index) {
            return Container(
              child: bottomMenu[isJump ? selectBtn : index],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 9 * SizeConfig.height!,
          // padding: EdgeInsets.symmetric(vertical: 1 * SizeConfig.height!),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: blue.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; navButtons.length > i; i++)
                InkWell(
                  onTap: () {
                    setState(() {
                      isJump = false;
                      controller.jumpToPage(i);
                      selectBtn = i;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        selectBtn == i ? navButtons[i].selectImage : navButtons[i].unselectImage,
                        height: 3.3 * SizeConfig.height!,
                        color: selectBtn == i ? blue : darkGrey,
                      ),
                      Text(
                        navButtons[i].name,
                        style: TextStyle(
                          color: selectBtn == i ? lightBlue : darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> bottomMenu = [
  const HomePage(),
  const ReportsPage(),
  const ProfilePage(),
];
