import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../text/bottom_nav_text.dart';
import 'padding.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key, required this.selectedPage, this.onTap}) : super(key: key);
  final int selectedPage;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: onTap,
        selectedFontSize: screenSize.width / 34,
        unselectedFontSize: screenSize.width / 34,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            tooltip: toolTiMyProfilePage,
            icon: PaddingWidget(
              type: 'only',
              onlyBottom: 7.5,
              child: Icon(FontAwesomeIcons.user),
            ),
            label: labelMyProfile,
          ),
          BottomNavigationBarItem(
            tooltip: toolTipWorkoutHistoryPage,
            icon: PaddingWidget(type: 'only', onlyBottom: 7.5, child: Icon(FontAwesomeIcons.clock)),
            label: labelWorkoutHistory,
          ),
          BottomNavigationBarItem(
            tooltip: toolTipStartWorkout,
            icon: PaddingWidget(type: 'only', onlyBottom: 7.5, child: Icon(FontAwesomeIcons.plusCircle)),
            label: labelStartWorkout,
          ),
          BottomNavigationBarItem(
            tooltip: toolTipAllExercises,
            icon: PaddingWidget(type: 'only', onlyBottom: 7.5, child: Icon(FontAwesomeIcons.dumbbell)),
            label: labelAllExercises,
          ),
          BottomNavigationBarItem(
            tooltip: toolTipStatistics,
            icon: PaddingWidget(type: 'only', onlyBottom: 7.5, child: Icon(FontAwesomeIcons.chartLine)),
            label: labelStatistics,
          ),
        ]);
  }
}
