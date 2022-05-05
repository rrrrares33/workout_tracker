import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  const ChartWeightEvolution({Key? key, required this.weightTracker}) : super(key: key);
  final WeightTracker weightTracker;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(
            text: 'Personal weight evolution', textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        palette: const <Color>[Colors.green],
        primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('dd/MM'),
            minorGridLines: const MinorGridLines(width: 0),
            majorGridLines: const MajorGridLines(width: 0)),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        margin: const EdgeInsets.all(15),
        series: <ChartSeries<dynamic, dynamic>>[
          AreaSeries<ChartData, DateTime>(
              dataSource: convertWeightTrackerToChartData(weightTracker),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'weight',
              yAxisName: 'weight',
              xAxisName: 'date',
              color: Colors.black26,
              isVisibleInLegend: true),
          ScatterSeries<ChartData, DateTime>(
            dataSource: convertWeightTrackerToChartData(weightTracker),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'recorded points',
            color: Colors.green,
            isVisibleInLegend: true,
          ),
        ]);
  }
}
