import 'package:flutter/material.dart';

import '../../../utils/models/user_database.dart';
import '../../reusable_widgets/bottom_nav.dart';
import 'all_exercises_page.dart';
import 'my_profile.dart';
import 'start_workout_page.dart';
import 'statistics_and_charts_page.dart';
import 'workout_history_page.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key, required this.user}) : super(key: key);
  final UserDB user;

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
      MyProfilePage(user: widget.user),
      WorkoutHistoryPage(user: widget.user),
      StartWorkoutPage(user: widget.user),
      AllExercisesPage(user: widget.user),
      StatisticsAndChartsPage(user: widget.user)
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
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
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
