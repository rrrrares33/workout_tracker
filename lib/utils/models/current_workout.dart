import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';

import 'exercise_set.dart';

class CurrentWorkout {
  CurrentWorkout() {
    workoutNotes.text = 'Notes';
    workoutName.text = 'Daily workout';
  }

  // Workout starting time
  DateTime? startTime;

  // Workout name
  TextEditingController workoutName = TextEditingController();

  // Workout notes
  TextEditingController workoutNotes = TextEditingController();

  // Exercises that were performed during the workout
  final List<ExerciseSet> sets = <ExerciseSet>[];

  // Things related to timer.
  final CountDownController timerController = CountDownController();
  Timer? timer;
  DateTime lastDecrementForTimer = DateTime.now();
  int currentTimeInSeconds = 0;
}
