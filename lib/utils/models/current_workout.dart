import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'exercise_set.dart';

class CurrentWorkout {
  CurrentWorkout();

  // Workout starting time
  DateTime? startTime;

  // Exercises that were performed during the workout
  final List<ExerciseSet> sets = <ExerciseSet>[];

  // Things related to timer.
  final CountDownController timerController = CountDownController();
  Timer? timer;
  DateTime lastDecrementForTimer = DateTime.now();
  int currentTimeInSeconds = 0;
}
