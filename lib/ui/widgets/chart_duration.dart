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
  final List<ChartData> returnList = <ChartData>[];
  for (final HistoryWorkout element in historyWorkouts) {
    final DateTime localDateTime = DateFormat('h:mm dd.MM.yyyy').parse(
        "${element.startTime?.replaceAll('  ', ' ').split(' ')[0].replaceAll(' ', '')} ${element.startTime?.replaceAll('  ', ' ').split(' ')[1].replaceAll(' ', '')}");
    final int? hours = int.tryParse(element.duration!.split(':')[0]);
    final int? minutes = int.tryParse(element.duration!.split(':')[1]);
    late final int totalTime;
    if (hours != null && minutes != null) {
      totalTime = hours * 60 + minutes;
    }
    if (totalTime != null) {
      returnList.add(ChartData(localDateTime, totalTime));
    }
  }
  return returnList;
}

class ChartDurationPerWorkout extends StatelessWidget {
  const ChartDurationPerWorkout({Key? key, required this.history}) : super(key: key);
  final List<HistoryWorkout> history;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        palette: const <Color>[Colors.green],
        primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round, numberFormat: NumberFormat('### min')),
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
              dataSource: convertHistoryWorkoutsToChartData(history),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              splineType: SplineType.monotonic,
              color: Colors.greenAccent[400],
              isVisibleInLegend: false),
          SplineAreaSeries<ChartData, DateTime>(
              dataSource: convertHistoryWorkoutsToChartData(history),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'time',
              yAxisName: 'time',
              xAxisName: 'date',
              splineType: SplineType.monotonic,
              color: Colors.black12,
              isVisibleInLegend: false),
          ScatterSeries<ChartData, DateTime>(
            dataSource: convertHistoryWorkoutsToChartData(history),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Time (in minutes)',
            color: Colors.green,
            isVisibleInLegend: true,
          ),
          ColumnSeries<ChartData, DateTime>(
            dataSource: convertHistoryWorkoutsToChartData(history),
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
