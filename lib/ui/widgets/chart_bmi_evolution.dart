import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../business_logic/my_profile_logic.dart';
import '../../utils/models/user_database.dart';
import '../../utils/models/weight_tracker.dart';

class ChartData {
  // Used to display statistics easily
  ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}

List<ChartData> convertWeightTrackerToChartData(WeightTracker weightTracker, double height, WeightMetric metric) {
  final List<ChartData> data = <ChartData>[];
  final List<double> weightsFromTracker = weightTracker.weights.toList();
  final List<DateTime> datesFromTracker = weightTracker.dates.toList();
  for (int i = 0; i < weightsFromTracker.length; i++) {
    data.add(ChartData(datesFromTracker[i], calculateBMI(weightsFromTracker[i], metric, height)));
  }
  return data;
}

List<ChartData> convertChartDataToBodyFat(List<ChartData> dataReceived, int userAge, String userSex) {
  final List<ChartData> data = <ChartData>[];
  for (int i = 0; i < dataReceived.length; i++) {
    late final double bodyFat;
    if (userSex == 'male') {
      bodyFat = 1.2 * dataReceived[i].y + 0.23 * userAge - 16.2;
    } else {
      bodyFat = 1.2 * dataReceived[i].y + 0.23 * userAge - 5.4;
    }
    data.add(ChartData(dataReceived[i].x, bodyFat));
  }
  return data;
}

class ChartBMIEvolution extends StatelessWidget {
  const ChartBMIEvolution({Key? key, required this.weightTracker, required this.user}) : super(key: key);
  final WeightTracker weightTracker;
  final UserDB user;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryYAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
        primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('dd/MM'),
            minorGridLines: const MinorGridLines(width: 0),
            majorGridLines: const MajorGridLines(width: 0)),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        margin: const EdgeInsets.all(15),
        series: <ChartSeries<dynamic, dynamic>>[
          LineSeries<ChartData, DateTime>(
              dataSource: convertWeightTrackerToChartData(weightTracker, user.height!, user.weightType!),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'B.M.I.',
              yAxisName: 'Body Mass Index',
              color: Colors.greenAccent,
              xAxisName: 'date',
              isVisibleInLegend: true),
          ScatterSeries<ChartData, DateTime>(
              dataSource: convertWeightTrackerToChartData(weightTracker, user.height!, user.weightType!),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'B.M.I.',
              yAxisName: 'Body Mass Index',
              color: Colors.green,
              xAxisName: 'date',
              isVisibleInLegend: false),
          LineSeries<ChartData, DateTime>(
              dataSource: convertChartDataToBodyFat(
                  convertWeightTrackerToChartData(weightTracker, user.height!, user.weightType!), user.age!, user.sex!),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '~ Body Fat %',
              yAxisName: 'Body Fat %',
              color: Colors.blueAccent,
              xAxisName: 'date',
              isVisibleInLegend: true),
          ScatterSeries<ChartData, DateTime>(
              dataSource: convertChartDataToBodyFat(
                  convertWeightTrackerToChartData(weightTracker, user.height!, user.weightType!), user.age!, user.sex!),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '~ Body Fat %',
              yAxisName: 'Body Fat %',
              color: Colors.blue,
              xAxisName: 'date',
              isVisibleInLegend: false),
          ColumnSeries<ChartData, DateTime>(
            dataSource: convertWeightTrackerToChartData(weightTracker, user.height!, user.weightType!),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Date',
            width: 0.1,
            color: Colors.green.withOpacity(0.3),
            isVisibleInLegend: true,
          ),
        ]);
  }
}
