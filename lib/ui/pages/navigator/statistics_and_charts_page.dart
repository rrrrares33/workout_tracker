import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/models/history_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/weight_tracker.dart';
import '../../widgets/chart_volume_per_workout.dart';
import '../../widgets/chart_weight_evolution.dart';
import '../../widgets/chart_workouts_per_week.dart';
import '../../widgets/sliver_top_bar.dart';

const double expandedHeight = 50;
const double toolbarHeight = 35;

class ChartData {
  // Used to display statistics easily
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class StatisticsAndChartsPage extends StatefulWidget {
  const StatisticsAndChartsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsAndChartsPage> createState() => _StatisticsAndChartsPageState();
}

class _StatisticsAndChartsPageState extends State<StatisticsAndChartsPage> {
  late ScrollController _scrollController;
  bool logoutPressed = false;

  bool get _showBigLeftTitle {
    return _scrollController.hasClients && _scrollController.offset > expandedHeight - toolbarHeight;
  }

  List<ChartData> convertWeightTrackerToChartData(WeightTracker weightTracker){
    final List<ChartData> data = <ChartData>[];
    final List<double> weightsFromTracker = weightTracker.weights.toList();
    final List<DateTime> datesFromTracker = weightTracker.dates.toList();
    for(int i = 0; i < weightsFromTracker.length; i++){
      data.add(ChartData(datesFromTracker[i], weightsFromTracker[i]));
    }
    return data;
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserDB user = Provider.of<UserDB>(context);
    final WeightTracker weightTracker = Provider.of<WeightTracker>(context);
    final List<HistoryWorkout> historyWorkouts = Provider.of<List<HistoryWorkout>>(context);
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      SliverTopBar(
          expandedHeight: expandedHeight,
          toolbarHeight: toolbarHeight,
          textExpanded: 'Statistics & Charts',
          textToolbar: 'Statistics & Charts',
          showBigTitle: _showBigLeftTitle),
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ChartWeightEvolution(weightTracker: weightTracker),
              ],
            ),
          ),
        ),
      )),
      SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ChartWorkoutsPerWeek(historyWorkouts : historyWorkouts),
                  ],
                ),
              ),
            ),
          )),

      SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ChartVolumePerWorkout(history : historyWorkouts, user: user),
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}
