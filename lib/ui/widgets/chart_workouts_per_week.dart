import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/models/history_workout.dart';

class ChartData {
  // Used to display statistics easily
  ChartData(this.x, this.y);

  // week - start - date
  final DateTime x;

  // nr. of workouts in that week
  int y;
}

List<ChartData> convertHistoryWorkoutsToChartData(List<HistoryWorkout> historyWorkouts) {
  List<ChartData> result = <ChartData>[];
  DateTime firstDayOfTheWeek = DateTime.now();
  while (firstDayOfTheWeek.weekday != 1) {
    if (firstDayOfTheWeek.day > 1)
      firstDayOfTheWeek = DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month, firstDayOfTheWeek.day - 1);
    else
      firstDayOfTheWeek = DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month - 1);
  }
  for (int i = 0; i < 7; i++) {
    late final DateTime weekToAdd;
    if (firstDayOfTheWeek.day - i * 7 > 0)
      weekToAdd = DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month, firstDayOfTheWeek.day - i * 7, 12);
    else {
      weekToAdd = DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month - 1,
          DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month, 0).day + firstDayOfTheWeek.day - i * 7, 12);
    }
    result.add(ChartData(weekToAdd, 0));
  }
  result = result.reversed.toList();
  final List<DateTime> historyDateTimes = <DateTime>[];
  for (final HistoryWorkout element in historyWorkouts) {
    historyDateTimes.add(DateFormat('dd.MM.yyyy')
        .parse(element.startTime?.replaceAll('  ', ' ').split(' ')[1].replaceAll(' ', '') ?? ''));
  }
  final Map<DateTime, int> resultMap = <DateTime, int>{};
  for (final DateTime element in historyDateTimes) {
    DateTime auxiliaryTime = element;
    while (auxiliaryTime.weekday != 1) {
      if (auxiliaryTime.day > 1)
        auxiliaryTime = DateTime(auxiliaryTime.year, auxiliaryTime.month, auxiliaryTime.day - 1);
      else
        auxiliaryTime = DateTime(auxiliaryTime.year, auxiliaryTime.month - 1);
    }
    if (resultMap.containsKey(auxiliaryTime)) {
      resultMap[auxiliaryTime] = resultMap[auxiliaryTime]! + 1;
    } else {
      resultMap[auxiliaryTime] = 1;
    }
  }
  resultMap.forEach((DateTime key, int value) {
    final DateTime auxTime = DateTime(key.year, key.month, key.day, 12);
    final int index = result.indexWhere((ChartData element) => element.x == auxTime);
    if (index != -1) result[index].y = value;
  });
  return result;
}

int getNrOfIntervals(List<ChartData> aux) {
  final Set<int> setList = <int>{};
  for (final ChartData element in aux) {
    if (element.y != 0) {
      setList.add(element.y);
    }
  }
  if (setList.length > 1) return setList.length - 1;
  return 0;
}

class ChartWorkoutsPerWeek extends StatelessWidget {
  const ChartWorkoutsPerWeek({Key? key, required this.historyWorkouts}) : super(key: key);
  final List<HistoryWorkout> historyWorkouts;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.round,
            maximumLabels: getNrOfIntervals(convertHistoryWorkoutsToChartData(historyWorkouts)),
            numberFormat: NumberFormat('### times')),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: DateTimeCategoryAxis(
            dateFormat: DateFormat('dd/MM'),
            minorGridLines: const MinorGridLines(width: 0),
            majorGridLines: const MajorGridLines(width: 0)),
        series: <ChartSeries<ChartData, DateTime>>[
          ColumnSeries<ChartData, DateTime>(
              dataSource: convertHistoryWorkoutsToChartData(historyWorkouts),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              width: 0.75,
              color: Colors.greenAccent,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              legendItemText: 'Workouts per week (X-Axis)')
        ]);
  }
}
