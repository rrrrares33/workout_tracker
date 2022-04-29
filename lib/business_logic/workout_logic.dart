import 'package:flutter/cupertino.dart';

import '../ui/text/start_workout_text.dart';
import '../utils/models/exercise_set.dart';

int convertTimeToSeconds(String? time) {
  if (time == null) {
    return 0;
  }
  if (!time.contains(':')) {
    return int.parse(time);
  }
  if (time.length == 5) {
    return int.parse(time[0] + time[1]) * 60 + int.parse(time[3] + time[4]);
  }
  // if time.length == 8
  return int.parse(time[0] + time[1]) * 60 * 60 + int.parse(time[3] + time[4]) * 60 + int.parse(time[6] + time[7]);
}

String getPrintableTimer(String secondsStr) {
  final int? parsedSeconds = int.tryParse(secondsStr);
  if (parsedSeconds == null) {
    return '';
  }
  final int seconds = parsedSeconds % 60;
  final int minutes = parsedSeconds ~/ 60 % 60;
  final int hours = parsedSeconds ~/ 3600 % 60;
  String hoursStr = '';
  if (hours!=0) {
    if (hours >= 10) {
      hoursStr = hours.toString();
    } else {
      hoursStr = '0$hours:';
    }
  }
  String minutesStr = '00:';
  if (minutes!=0) {
    if (minutes >= 10) {
      minutesStr = '$minutes:';
    } else {
      minutesStr = '0$minutes:';
    }
  }
  String secondsSt = '00';
  if (seconds!=0) {
    if (seconds >= 10) {
      secondsSt = '$seconds';
    } else {
      secondsSt = '0$seconds';
    }
  }
  if(hours == 0 && minutes == 0){
    minutesStr = '';
  }
  return hoursStr + minutesStr + secondsSt;
}

String getPrintableTimerSinceStart(String seconds) {
  final String res = getPrintableTimer(seconds);
  if (res.length == 2) {
    return '0:$res';
  }
  if (res.length == 1) {
    return '0:0$res';
  }
  return res;
}

bool checkForEmptySets(List<List<TextEditingController>> aux) {
  // true - there is at least one empty set in the exercise
  // false - there are no empty sets in the exercise
  for (final List<TextEditingController> set in aux) {
    if (set[2].text != checkedText) {
      return true;
    }
  }
  return false;
}

bool checkForEmptySetsMultipleExercises(List<ExerciseSet> exercisesSets) {
  for (final ExerciseSet exerciseSet in exercisesSets) {
    if (checkForEmptySets(exerciseSet.sets)) {
      return true;
    }
  }
  return false;
}

List<ExerciseSet> removeEmptyExercises(List<ExerciseSet> exerciseSets) {
  final List<ExerciseSet> finalList = <ExerciseSet>[];
  for (final ExerciseSet exerciseSet in exerciseSets) {
    if (exerciseSet.sets.isNotEmpty) {
      if (checkForEmptySets(exerciseSet.sets)) {
        final List<List<TextEditingController>> finalCheckedSets = <List<TextEditingController>>[];
        for (final List<TextEditingController> set in exerciseSet.sets) {
          if (set[2].text == checkedText) {
            finalCheckedSets.add(set);
          }
        }
        exerciseSet.sets.clear();
        exerciseSet.sets.addAll(finalCheckedSets);
      }
      if (exerciseSet.sets.isNotEmpty) {
        finalList.add(exerciseSet);
      }
    }
  }
  return finalList;
}

bool validateWorkoutSets(List<ExerciseSet> exerciseSets) {
  return removeEmptyExercises(exerciseSets).isNotEmpty;
}
