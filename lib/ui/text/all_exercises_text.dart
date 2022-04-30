import 'package:flutter/material.dart';

import '../widgets/text.dart';

const String defaultBodyPart = 'Any Body Part';
const String defaultCategory = 'Any Category';
const String placeHolderSearchBar = 'Search...';
const String topSliverText = 'All Exercises';
const String noExerciseFound = 'No Exercises Found';
const String useOtherFilters1 = 'Please try a different combination of filters';
const String useOtherFilters2 = 'or create a new exercise';
const String addNewExerciseText = 'Add a new exercise';

const List<String> category = <String>[
  'Time',
  'Cable',
  'Barbell',
  'Machine',
  'Dumbbell',
  'Bodyweight',
  'Any Category',
  'Assisted Bodyweight',
];

const List<String> bodyPart = <String>[
  'Core',
  'Legs',
  'Back',
  'Chest',
  'Biceps',
  'Triceps',
  'Forearms',
  'Shoulders',
  'Any Body Part',
];

SnackBar newExerciseAddedToWorkout = SnackBar(
  content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[TextWidget(text: 'New exercise added to workout.')]),
  duration: const Duration(seconds: 2),
);

SnackBar newExerciseAddedToTemplate = SnackBar(
  content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[TextWidget(text: 'New exercise added to template.')]),
  duration: const Duration(seconds: 2),
);
