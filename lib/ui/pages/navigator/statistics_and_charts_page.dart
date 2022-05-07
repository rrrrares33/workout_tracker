import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/models/history_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/weight_tracker.dart';
import '../../widgets/chart_bmi_evolution.dart';
import '../../widgets/chart_duration.dart' as duration;
import '../../widgets/chart_duration.dart';
import '../../widgets/chart_volume_per_workout.dart';
import '../../widgets/chart_weight_evolution.dart';
import '../../widgets/chart_workouts_per_week.dart';
import '../../widgets/padding.dart';
import '../../widgets/sliver_top_bar.dart';
import '../../widgets/statistics.dart';
import '../../widgets/text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 35;

class StatisticsAndChartsPage extends StatefulWidget {
  const StatisticsAndChartsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsAndChartsPage> createState() => _StatisticsAndChartsPageState();
}

class _StatisticsAndChartsPageState extends State<StatisticsAndChartsPage> {
  late ScrollController _scrollController;
  final List<bool> personalWeightTracker = <bool>[false];
  final List<bool> personalBMIChart = <bool>[true];

  final List<bool> timesPerWeekChart = <bool>[true];
  final List<bool> volumeChart = <bool>[false];
  final List<bool> durationChart = <bool>[false];

  Widget returnChartForPersonal(WeightTracker tracker, UserDB user) {
    if (personalWeightTracker[0] == true) {
      return ChartWeightEvolution(
        weightTracker: tracker,
        user: user,
      );
    }
    if (personalBMIChart[0] == true) {
      return ChartBMIEvolution(weightTracker: tracker, user: user);
    }
    return ChartWeightEvolution(
      weightTracker: tracker,
      user: user,
    );
  }

  Widget returnChartForWorkout(List<HistoryWorkout> history, UserDB user) {
    if (volumeChart[0] == true) {
      return ChartVolumePerWorkout(
        user: user,
        history: history,
      );
    }
    if (timesPerWeekChart[0] == true) {
      return ChartWorkoutsPerWeek(historyWorkouts: history);
    }
    return ChartDurationPerWorkout(history: history);
  }

  bool get _showBigLeftTitle {
    return _scrollController.hasClients && _scrollController.offset > expandedHeight - toolbarHeight;
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
    final Size screenSize = MediaQuery.of(context).size;

    duration.convertHistoryWorkoutsToChartData(historyWorkouts);

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
                PaddingWidget(
                  type: 'all',
                  all: screenSize.height / 100,
                  child: TextWidget(
                    text: 'Personal Weight Charts',
                    fontSize: screenSize.height / 40,
                    weight: FontWeight.bold,
                  ),
                ),
                PaddingWidget(
                  type: 'only',
                  onlyTop: screenSize.height / 400,
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      ToggleButtons(
                        isSelected: personalBMIChart,
                        borderRadius: BorderRadius.circular(15.0),
                        borderWidth: 2,
                        fillColor: Colors.greenAccent,
                        selectedColor: Colors.grey[700],
                        onPressed: (int index) {
                          setState(() {
                            personalWeightTracker[0] = false;
                            personalBMIChart[0] = true;
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: screenSize.height / 20,
                        ),
                        children: <Widget>[
                          PaddingWidget(
                              type: 'symmetric',
                              horizontal: screenSize.width / 100,
                              child: TextWidget(
                                text: 'B.M.I. evolution',
                                fontSize: screenSize.width / 35,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const Spacer(),
                      ToggleButtons(
                        isSelected: personalWeightTracker,
                        borderRadius: BorderRadius.circular(15.0),
                        borderWidth: 2,
                        onPressed: (int index) {
                          setState(() {
                            personalWeightTracker[0] = true;
                            personalBMIChart[0] = false;
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: screenSize.height / 20,
                        ),
                        fillColor: Colors.greenAccent,
                        selectedColor: Colors.grey[700],
                        children: <Widget>[
                          PaddingWidget(
                              type: 'symmetric',
                              horizontal: screenSize.width / 100,
                              child: TextWidget(
                                text: 'Weight evolution',
                                fontSize: screenSize.width / 35,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height / 3.33, child: returnChartForPersonal(weightTracker, user)),
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
                PaddingWidget(
                  type: 'all',
                  all: screenSize.height / 100,
                  child: TextWidget(
                    text: 'Workout Charts',
                    fontSize: screenSize.height / 40,
                    weight: FontWeight.bold,
                  ),
                ),
                PaddingWidget(
                  type: 'only',
                  onlyTop: screenSize.height / 400,
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      ToggleButtons(
                        isSelected: timesPerWeekChart,
                        borderRadius: BorderRadius.circular(15.0),
                        borderWidth: 2,
                        fillColor: Colors.greenAccent,
                        selectedColor: Colors.grey[700],
                        onPressed: (int index) {
                          setState(() {
                            durationChart[0] = false;
                            timesPerWeekChart[0] = true;
                            volumeChart[0] = false;
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: screenSize.height / 20,
                        ),
                        children: <Widget>[
                          PaddingWidget(
                              type: 'symmetric',
                              horizontal: screenSize.width / 50,
                              child: TextWidget(
                                text: 'Times/week',
                                fontSize: screenSize.width / 35,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const Spacer(),
                      ToggleButtons(
                        isSelected: volumeChart,
                        borderRadius: BorderRadius.circular(15.0),
                        borderWidth: 2,
                        onPressed: (int index) {
                          setState(() {
                            durationChart[0] = false;
                            timesPerWeekChart[0] = false;
                            volumeChart[0] = true;
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: screenSize.height / 20,
                        ),
                        fillColor: Colors.greenAccent,
                        selectedColor: Colors.grey[700],
                        children: <Widget>[
                          PaddingWidget(
                              type: 'symmetric',
                              horizontal: screenSize.width / 50,
                              child: TextWidget(
                                text: 'Volume',
                                fontSize: screenSize.width / 35,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const Spacer(),
                      ToggleButtons(
                        isSelected: durationChart,
                        borderRadius: BorderRadius.circular(15.0),
                        borderWidth: 2,
                        fillColor: Colors.greenAccent,
                        selectedColor: Colors.grey[700],
                        onPressed: (int index) {
                          setState(() {
                            durationChart[0] = true;
                            timesPerWeekChart[0] = false;
                            volumeChart[0] = false;
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: screenSize.height / 20,
                        ),
                        children: <Widget>[
                          PaddingWidget(
                              type: 'symmetric',
                              horizontal: screenSize.width / 50,
                              child: TextWidget(
                                text: 'Duration',
                                fontSize: screenSize.width / 35,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height / 3, child: returnChartForWorkout(historyWorkouts, user)),
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        PaddingWidget(
                          type: 'all',
                          all: screenSize.height / 100,
                          child: Statistics(history: historyWorkouts, user: user, screenSize: screenSize),
                        )
                      ]))))),
    ]);
  }
}
