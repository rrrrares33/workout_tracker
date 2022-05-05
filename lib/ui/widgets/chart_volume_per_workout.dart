import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../business_logic/workout_history_logic.dart';
import '../../utils/models/history_workout.dart';
import '../../utils/models/user_database.dart';

class ChartData {
  // Used to display statistics easily
  ChartData(this.x, this.y);

  // week - start - date
  final DateTime x;

  // nr. of workouts in that week
  double y;
}

List<ChartData> convertHistoryWorkoutsToChartData(List<HistoryWorkout> historyWorkouts, UserDB user) {
  final List<ChartData> returnList = <ChartData>[];
  for (final HistoryWorkout element in historyWorkouts) {
    final DateTime localDateTime = DateFormat('h:mm dd.MM.yyyy').parse(
        "${element.startTime?.replaceAll('  ', ' ').split(' ')[0].replaceAll(' ', '')} ${element.startTime?.replaceAll('  ', ' ').split(' ')[1].replaceAll(' ', '')}");
    final String totalWeightString = getTotalWeightOfAnWorkout(element.exercises, user.weight!, user.weightType!);
    final double? totalWeight = double.tryParse(totalWeightString.substring(0, totalWeightString.length - 3));
    returnList.add(ChartData(localDateTime, totalWeight!));
  }
  return returnList;
}

class ChartVolumePerWorkout extends StatelessWidget {
  const ChartVolumePerWorkout({Key? key, required this.history, required this.user}) : super(key: key);
  final UserDB user;
  final List<HistoryWorkout> history;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(
            text: 'Volume per workout', textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        palette: const <Color>[Colors.green],
        primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.round,
        ),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('dd/MM'),
          minorGridLines: const MinorGridLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          rangePadding: ChartRangePadding.auto,
        ),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        margin: const EdgeInsets.all(15),
        series: <ChartSeries<dynamic, dynamic>>[
          SplineSeries<ChartData, DateTime>(
              dataSource: convertHistoryWorkoutsToChartData(history, user),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              color: Colors.black26,
              isVisibleInLegend: false),
          ScatterSeries<ChartData, DateTime>(
            dataSource: convertHistoryWorkoutsToChartData(history, user),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'total workout volume',
            color: Colors.green,
            isVisibleInLegend: true,
          ),
        ]);
  }
}
