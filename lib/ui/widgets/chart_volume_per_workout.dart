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
        palette: const <Color>[Colors.green],
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.round,
            numberFormat: NumberFormat.compactCurrency(
              symbol: 'kg. ',
            )),
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
              splineType: SplineType.monotonic,
              color: Colors.greenAccent[400],
              isVisibleInLegend: false),
          SplineAreaSeries<ChartData, DateTime>(
              dataSource: convertHistoryWorkoutsToChartData(history, user),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              splineType: SplineType.monotonic,
              color: Colors.black12,
              isVisibleInLegend: false),
          ScatterSeries<ChartData, DateTime>(
            dataSource: convertHistoryWorkoutsToChartData(history, user),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Volume per workout(kg)',
            color: Colors.green,
            isVisibleInLegend: true,
          ),
          ColumnSeries<ChartData, DateTime>(
            dataSource: convertHistoryWorkoutsToChartData(history, user),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Record Date',
            width: 0.1,
            color: Colors.green.withOpacity(0.3),
            isVisibleInLegend: true,
          ),
        ]);
  }
}
