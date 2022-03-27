// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'padding.dart';
import 'text.dart';

class CalendarHistoryWorkouts extends StatelessWidget {
  const CalendarHistoryWorkouts({
    Key? key,
    required this.width,
    required this.workouts,
    required this.height,
  }) : super(key: key);
  final List<DateTime> workouts;
  final double width;
  final double height;

  bool dateInWorkouts(DateTime date) {
    bool found = false;
    workouts.forEach((DateTime element) {
      if (date.compareTo(element) == 0) {
        found = true;
      }
    });
    return found;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext auxContext) => AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                title: TextWidget(
                  text: 'Workout Calendar',
                  fontSize: width / 20,
                  weight: FontWeight.bold,
                ),
                content: SizedBox(
                    width: width / 2.5,
                    height: height / 1.5,
                    child: PagedVerticalCalendar(
                      dayBuilder: (BuildContext context, DateTime date) {
                        return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: dateInWorkouts(date) ? Colors.greenAccent[400] : null),
                            child: Center(child: TextWidget(text: date.day.toString())));
                      },
                    )))),
        child: PaddingWidget(
          type: 'only',
          onlyRight: width / 30,
          child: Icon(
            FontAwesomeIcons.calendarDay,
            color: Colors.greenAccent[400],
          ),
        ),
      ),
    );
  }
}
