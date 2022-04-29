// ignore_for_file: implementation_imports
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:intl/intl.dart';

import '../utils/models/exercise_set.dart';
import '../utils/models/history_workout.dart';
import '../utils/models/user_database.dart';

String getDateAndTimeForPrinting(String hoursSpaceDate) {
  late final String result;
  late final List<String> splitInput;
  try {
    splitInput = hoursSpaceDate.split(' ');
    splitInput[1] = splitInput[2];

    final int hours = int.parse(splitInput[0].split(':')[0]);
    final int minutes = int.parse(splitInput[0].split(':')[1]);
    final int day = int.parse(splitInput[1].split('.')[0]);
    final int month = int.parse(splitInput[1].split('.')[1]);
    final int year = int.parse(splitInput[1].split('.')[2]);
    final DateTime workoutDateTime = DateTime(year, month, day, hours, minutes);
    result = '${DateFormat('EEEE').format(workoutDateTime)}   $day ${DateFormat.MMMM().format(workoutDateTime)} $year';
    return result;
  } on Exception catch (_) {
    return '';
  }
}

String getWorkoutLengthForPrinting(String duration) {
  late final String result;
  try{
    final List<String> splitInput = duration.split(':');
    final int? hours = int.tryParse(splitInput[0]);
    final int? minutes = int.tryParse(splitInput[1]);
    if (hours! == 0) {
      result = '${minutes}m';
    } else {
      result = '${hours}h ${minutes}m';
    }
    return result;
  } on RangeError catch (_) {
    return '';
  }
}

String getTotalWeightOfAnWorkout(List<ExerciseSet> exercises, double userWeight, WeightMetric metric) {
  double totalSum = 0;
  if (metric == WeightMetric.LBS) {
    userWeight *= 0.45359237;
  }
  // ignore_for_file: avoid_function_literals_in_foreach_calls
  exercises.forEach((ExerciseSet element) {
    if (element.type != 'ExerciseSetDuration') {
      element.sets.forEach((List<TextEditingController> currentSet) {
        late final double reps;
        late final double kgs;
        reps = double.tryParse(currentSet[0].text)!;
        kgs = double.tryParse(currentSet[1].text)!;
        if (element.type == 'ExerciseSetWeight') {
          if (element.assignedExercise.category == 'Bodyweight') {
            totalSum += reps * (kgs + userWeight);
          } else {
            totalSum += reps * kgs;
          }
        } else {
          totalSum += reps * (userWeight - kgs);
        }
      });
    }
  });
  return '$totalSum kg';
}

String reduceString(String stringToReduce, int aux) {
  if (aux + 2 > stringToReduce.length) {
    return stringToReduce;
  }
  stringToReduce = stringToReduce.substring(0, aux).trim();
  stringToReduce += '..';
  return stringToReduce;
}

String getBestSet(ExerciseSet fullExercise, double weight, WeightMetric metric) {
  late final String result;
  if (metric == WeightMetric.LBS) {
    weight *= 0.45359237;
  }
  if (fullExercise.type == 'ExerciseSetWeight') {
    if (fullExercise.assignedExercise.category != 'Bodyweight') {
      weight = 0;
    }
    int bestPos = 0;
    double bestValue =
        double.parse(fullExercise.sets[0][0].text) * (double.parse(fullExercise.sets[0][1].text) + weight);
    for (int i = 1; i < fullExercise.sets.length; i += 1) {
      final double currentValue =
          double.parse(fullExercise.sets[i][0].text) * (double.parse(fullExercise.sets[i][1].text) + weight);
      if (currentValue > bestValue) {
        bestValue = currentValue;
        bestPos = i;
      }
    }
    if (fullExercise.sets[bestPos][1].text == '0') {
      result = '${fullExercise.sets[bestPos][0].text}reps';
    } else {
      result = '${fullExercise.sets[bestPos][1].text}kg x ${fullExercise.sets[bestPos][0].text}reps';
    }
  } else if (fullExercise.type == 'ExerciseSetMinusWeight') {
    int bestPos = 0;
    double bestValue =
        double.parse(fullExercise.sets[0][0].text) * (weight - double.parse(fullExercise.sets[0][1].text));
    for (int i = 1; i < fullExercise.sets.length; i += 1) {
      final double currentValue =
          double.parse(fullExercise.sets[i][0].text) * (weight - double.parse(fullExercise.sets[i][1].text));
      if (currentValue > bestValue) {
        bestValue = currentValue;
        bestPos = i;
      }
    }
    result = '${fullExercise.sets[bestPos][1].text}kg x ${fullExercise.sets[bestPos][0].text}reps';
  } else {
    String bestValue = fullExercise.sets[0][0].text;
    for (int i = 1; i < fullExercise.sets.length; i += 1) {
      final String currentValue = fullExercise.sets[i][0].text;
      if (bestValue.compareTo(currentValue) < 0) {
        bestValue = currentValue;
      }
    }
    result = bestValue;
  }
  return result;
}

List<DateTime> getAllDateTimesOfWorkouts(List<HistoryWorkout> workouts) {
  final List<DateTime> result = <DateTime>[];
  workouts.forEach((HistoryWorkout element) {
    final String date = element.startTime!.substring(element.startTime!.indexOf(' ') + 2);
    final DateTime resultedDate = DateFormat('dd.MM.yyyy').parseLoose(date);
    result.add(resultedDate);
  });
  return result;
}
