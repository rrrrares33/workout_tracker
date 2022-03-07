import 'package:flutter/material.dart';

import '../../reusable_widgets/bottom_nav.dart';
import 'all_exercises_page.dart';
import 'my_profile.dart';
import 'start_workout_page.dart';
import 'statistics_and_charts_page.dart';
import 'workout_history_page.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  static late bool _logoutPressed;
  static late int _currentPageIndex;
  static late List<Widget> _pageOptions;

  @override
  void initState() {
    _pageOptions = <Widget>[
      const MyProfilePage(),
      const WorkoutHistoryPage(),
      const StartWorkoutPage(),
      const AllExercisesPage(),
      const StatisticsAndChartsPage()
    ];
    _currentPageIndex = 2;
    _logoutPressed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _logoutPressed,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarWidget(
          selectedPage: _currentPageIndex,
          onTap: (int _tappedIconOrder) {
            setState(() {
              _currentPageIndex = _tappedIconOrder;
            });
          },
        ),
        body: _pageOptions[_currentPageIndex],
      ),
    );
  }
}
