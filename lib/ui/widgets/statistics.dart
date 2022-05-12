import 'dart:math';

import 'package:flutter/material.dart';

import '../../utils/models/history_workout.dart';
import '../../utils/models/user_database.dart';
import 'chart_duration.dart' as duration;
import 'chart_volume_per_workout.dart' as volume;
import 'chart_workouts_per_week.dart' as week;
import 'padding.dart';
import 'text.dart';

double getAverageTimePerWorkout(List<HistoryWorkout> history) {
  final List<duration.ChartData> result = duration.convertHistoryWorkoutsToChartData(history);
  double sum = 0.0;
  for (final duration.ChartData element in result) {
    sum += element.y;
  }
  return sum / result.length;
}

double getAverageWorkoutsPerWeek(List<HistoryWorkout> history) {
  final List<week.ChartData> result = week.convertHistoryWorkoutsToChartData(history);
  int sum = 0;
  int weeksWithWorkout = 0;
  for (final week.ChartData element in result) {
    if (element.y != 0) {
      weeksWithWorkout += 1;
      sum += element.y;
    }
  }
  return sum / weeksWithWorkout;
}

double getAverageWorkoutVolume(List<HistoryWorkout> history, UserDB user) {
  final List<volume.ChartData> result = volume.convertHistoryWorkoutsToChartData(history, user);
  double sum = 0.0;
  for (final volume.ChartData element in result) {
    sum += element.y;
  }
  return sum / result.length;
}

double getBiggestWorkoutVolume(List<HistoryWorkout> history, UserDB user) {
  final List<volume.ChartData> result = volume.convertHistoryWorkoutsToChartData(history, user);
  double sum = 0.0;
  for (final volume.ChartData element in result) {
    sum = max(element.y, sum);
  }
  return sum;
}

double getTotalWorkoutVolume(List<HistoryWorkout> history, UserDB user) {
  final List<volume.ChartData> result = volume.convertHistoryWorkoutsToChartData(history, user);
  double sum = 0.0;
  for (final volume.ChartData element in result) {
    sum += element.y;
  }
  return sum;
}

class Statistics extends StatelessWidget {
  const Statistics({Key? key, required this.history, required this.user, required this.screenSize}) : super(key: key);
  final List<HistoryWorkout> history;
  final UserDB user;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextWidget(
          text: 'Workout Statistics',
          fontSize: screenSize.height / 40,
          weight: FontWeight.bold,
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Average time per workout: ${getAverageTimePerWorkout(history)} minutes',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Average workouts per week:  ${getAverageWorkoutsPerWeek(history)} workouts',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Average volume per workout: ${getAverageWorkoutVolume(history, user)} kg.',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Most workout volume: ${getBiggestWorkoutVolume(history, user)} kg.',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Total workouts performed: ${history.length} workouts',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
        PaddingWidget(type: 'symmetric', vertical: screenSize.height / 300),
        Card(
          color: Colors.grey.withOpacity(0.01),
          child: PaddingWidget(
            type: 'all',
            all: screenSize.width / 100,
            child: TextWidget(
              text: '  Total workout volume: ${getTotalWorkoutVolume(history, user)} kg.',
              fontSize: screenSize.height / 60,
            ),
          ),
        ),
      ],
    );
  }
}
