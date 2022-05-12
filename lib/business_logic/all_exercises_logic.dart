import 'package:flutter/foundation.dart';
// ignore_for_file: implementation_imports
import 'package:flutter/src/widgets/editable_text.dart';

import '../ui/text/all_exercises_text.dart';
import '../utils/models/exercise.dart';
import '../utils/models/exercise_set.dart';
import '../utils/models/history_workout.dart';

List<Exercise> filterBasedOnCategory(List<Exercise> exerciseList, String selectedCategory) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.category == selectedCategory) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterBasedOnBodyPart(List<Exercise> exerciseList, String selectedBodyPart) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.bodyPart == selectedBodyPart) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterBasedOnName(List<Exercise> exerciseList, String searchBoxText) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.name.toLowerCase().contains(searchBoxText.toLowerCase())) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterResults(
    List<Exercise> exerciseList, String selectedCategory, String selectedBodyPart, String searchBoxText) {
  if (selectedCategory != defaultCategory) {
    exerciseList = filterBasedOnCategory(exerciseList, selectedCategory);
  }
  if (selectedBodyPart != defaultBodyPart) {
    exerciseList = filterBasedOnBodyPart(exerciseList, selectedBodyPart);
  }
  if (searchBoxText != '') {
    exerciseList = filterBasedOnName(exerciseList, searchBoxText);
  }
  return exerciseList;
}

String getRPMForExercise(List<HistoryWorkout> history, String exerciseId, String exerciseCategory) {
  try {
    if (exerciseCategory.contains('Assisted')) {
      double? bestMinusWeight;
      for (final HistoryWorkout singleHistoryWorkout in history) {
        for (final ExerciseSet exerciseSet in singleHistoryWorkout.exercises) {
          if (exerciseSet.assignedExercise.id == exerciseId) {
            for (final List<TextEditingController> set in exerciseSet.sets) {
              if (bestMinusWeight == null) {
                bestMinusWeight = double.parse(set[1].text);
              } else {
                final double potentialMinusWeight = double.parse(set[1].text);
                if (potentialMinusWeight > bestMinusWeight) {
                  bestMinusWeight = potentialMinusWeight;
                }
              }
            }
          }
        }
      }
      if (bestMinusWeight == null) {
        return '';
      }
      return '-${bestMinusWeight.toString()} KG.';
    } else if (exerciseCategory.contains('Time')) {
      int? bestTime;
      for (final HistoryWorkout singleHistoryWorkout in history) {
        for (final ExerciseSet exerciseSet in singleHistoryWorkout.exercises) {
          if (exerciseSet.assignedExercise.id == exerciseId) {
            for (final List<TextEditingController> set in exerciseSet.sets) {
              if (bestTime == null) {
                final int minutes = int.parse(set[0].text.split(':')[0]);
                final int seconds = int.parse(set[0].text.split(':')[1]);
                bestTime = minutes * 60 + seconds;
              } else {
                final int minutes = int.parse(set[0].text.split(':')[0]);
                final int seconds = int.parse(set[0].text.split(':')[1]);
                final int potentialTime = minutes * 60 + seconds;
                if (potentialTime > bestTime) {
                  bestTime = potentialTime;
                }
              }
            }
          }
        }
      }
      if (bestTime == null) {
        return '';
      }
      return '${bestTime.toString()} seconds';
    } else {
      double? bestWeight;
      for (final HistoryWorkout singleHistoryWorkout in history) {
        for (final ExerciseSet exerciseSet in singleHistoryWorkout.exercises) {
          if (exerciseSet.assignedExercise.id == exerciseId) {
            for (final List<TextEditingController> set in exerciseSet.sets) {
              if (bestWeight == null) {
                bestWeight = double.parse(set[1].text);
              } else {
                final double potentialWeight = double.parse(set[1].text);
                if (potentialWeight > bestWeight) {
                  bestWeight = potentialWeight;
                }
              }
            }
          }
        }
      }
      if (bestWeight == null) {
        return '';
      }
      return '${bestWeight.toString()} KG.';
    }
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return '';
  }
}
