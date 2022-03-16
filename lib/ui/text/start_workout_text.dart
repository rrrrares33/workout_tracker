import 'package:flutter/material.dart';

import '../reusable_widgets/text.dart';

const String timerName = 'Rest Timer';
const String increment10Sec = '+ 10 sec.';
const String increment30Sec = '+ 30 sec.';
const String increment60Sec = '+ 60 sec.';
const String decrement10Sec = ' - 10 sec.';
const String decrement30Sec = '- 30 sec. ';
const String decrement60Sec = '- 60 sec.';
const String oneMinute = '1 min.';
const String twoMinutes = '2 min.';
const String threeMinutes = '3 min.';
const String finishText = 'Finish';
const String pickYourTime = 'Pick your rest time:';
const String startWorkout = 'Start Workout';
const String quickStart = 'Quick Start';
const String startEmptyWorkout = 'Begin  A  New  Empty  Workout';
const String defaultWorkoutTile = 'Daily Workout';
const String defaultWorkoutNote = 'Notes';
const String addANewExerciseToWorkout = 'Add a new exercise';
const String cancelWorkout = 'Cancel workout';
SnackBar swipeRightAndPressToAddExercise = SnackBar(
  content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[TextWidget(text: 'Swipe on an exercise and press on the "Add" icon')]),
  duration: const Duration(seconds: 2),
);
