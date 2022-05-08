import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/models/user_database.dart';
import '../../utils/models/weight_tracker.dart';

class ChartData {
  // Used to display statistics easily
  ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}

List<ChartData> convertWeightTrackerToChartData(WeightTracker weightTracker) {
  final List<ChartData> data = <ChartData>[];
  final List<double> weightsFromTracker = weightTracker.weights.toList();
  final List<DateTime> datesFromTracker = weightTracker.dates.toList();
  for (int i = 0; i < weightsFromTracker.length; i++) {
    data.add(ChartData(datesFromTracker[i], weightsFromTracker[i]));
  }
  return data;
}

class ChartWeightEvolution extends StatelessWidget {
  const ChartWeightEvolution({Key? key, required this.weightTracker, required this.user, required this.showLabels})
      : super(key: key);
  final WeightTracker weightTracker;
  final UserDB user;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        palette: const <Color>[Colors.green],
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('dd/MM'),
          minorGridLines: const MinorGridLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat('### ${user.weightType.toString().replaceAll('WeightMetric.', '')}'),
        ),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        margin: const EdgeInsets.all(15),
        series: <ChartSeries<dynamic, dynamic>>[
          SplineAreaSeries<ChartData, DateTime>(
              dataSource: convertWeightTrackerToChartData(weightTracker),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              color: Colors.black12,
              isVisibleInLegend: false),
          SplineSeries<ChartData, DateTime>(
              dataSource: convertWeightTrackerToChartData(weightTracker),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'Weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              color: Colors.greenAccent[400],
              isVisibleInLegend: true),
          ScatterSeries<ChartData, DateTime>(
            dataSource: convertWeightTrackerToChartData(weightTracker),
            dataLabelSettings: DataLabelSettings(
              isVisible: showLabels,
              textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 9),
            ),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Recorded date',
            color: Colors.green,
            isVisibleInLegend: true,
          ),
        ]);
  }
}
