import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routing/current_opened_page.dart';
import '../../widgets/bottom_nav.dart';
import 'all_exercises_page.dart';
import 'my_profile.dart';
import 'statistics_and_charts_page.dart';
import 'workout_history_page.dart';
import 'workout_page.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  static late bool _logoutPressed;
  static late List<Widget> _pageOptions;

  void callBackToAnotherPage(int newPage) {
    if (mounted) {
      // I need this in order to switch pages when an event happens inside of one of the _pageOptions
      setState(() {
        CurrentOpenedPage.currentOpenedIndex = newPage;
      });
    }
  }

  @override
  void initState() {
    _pageOptions = <Widget>[
      MyProfilePage(callback: callBackToAnotherPage),
      const WorkoutHistoryPage(),
      StartWorkoutPage(callback: callBackToAnotherPage),
      AllExercisesPage(callback: callBackToAnotherPage),
      const StatisticsAndChartsPage()
    ];
    _logoutPressed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentOpenedPage _ = Provider.of<CurrentOpenedPage>(context);

    return WillPopScope(
      onWillPop: () async => _logoutPressed,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarWidget(
          selectedPage: CurrentOpenedPage.currentOpenedIndex ?? 2,
          onTap: (int _tappedIconOrder) {
            setState(() {
              CurrentOpenedPage.currentOpenedIndex = _tappedIconOrder;
            });
          },
        ),
        body: _pageOptions[CurrentOpenedPage.currentOpenedIndex ?? 2],
      ),
    );
  }
}
