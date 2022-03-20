import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/models/history_workout.dart';
import '../../reusable_widgets/text.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  bool logoutPressed = false;

  @override
  Widget build(BuildContext context) {
    final List<HistoryWorkout> historyWorkouts = Provider.of<List<HistoryWorkout>>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: TextWidget(
            text: historyWorkouts.length.toString(),
          ),
        )
      ],
    );
  }
}
