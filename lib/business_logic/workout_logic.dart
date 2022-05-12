import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import '../ui/text/start_workout_text.dart';
import '../utils/firebase/database_service.dart';
import '../utils/firebase/firebase_service.dart';
import '../utils/models/current_workout.dart';
import '../utils/models/editing_template.dart';
import '../utils/models/exercise_set.dart';
import '../utils/models/user_database.dart';
import '../utils/models/workout_template.dart';

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
  if (hours != 0) {
    if (hours >= 10) {
      hoursStr = hours.toString();
    } else {
      hoursStr = '0$hours:';
    }
  }
  String minutesStr = '00:';
  if (minutes != 0) {
    if (minutes >= 10) {
      minutesStr = '$minutes:';
    } else {
      minutesStr = '0$minutes:';
    }
  }
  String secondsSt = '00';
  if (seconds != 0) {
    if (seconds >= 10) {
      secondsSt = '$seconds';
    } else {
      secondsSt = '0$seconds';
    }
  }
  if (hours == 0 && minutes == 0) {
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

void copyTemplateToEditingTemplate(EditingTemplate editingTemplate, WorkoutTemplate templateToCopy) {
  editingTemplate.currentlyEditing = true;
  editingTemplate.editingTemplateId = templateToCopy.id;
  editingTemplate.templateName = TextEditingController(text: templateToCopy.name);
  editingTemplate.templateNotes = TextEditingController(text: templateToCopy.notes);
  for (final ExerciseSet element in templateToCopy.exercises) {
    late final ExerciseSet newExercise;
    if (element.type == 'ExerciseSetWeight') {
      newExercise = ExerciseSetWeight(element.assignedExercise);
      newExercise.type = 'ExerciseSetWeight';
    } else if (element.type == 'ExerciseSetMinusWeight') {
      newExercise = ExerciseSetMinusWeight(element.assignedExercise);
      newExercise.type = 'ExerciseSetMinusWeight';
    } else {
      newExercise = ExerciseSetDuration(element.assignedExercise);
      newExercise.type = 'ExerciseSetDuration';
    }
    editingTemplate.exercises.add(newExercise);
    final int nrOfSets = element.sets.length;
    editingTemplate.exercises[editingTemplate.exercises.length - 1].sets.add(<TextEditingController>[
      TextEditingController(text: nrOfSets.toString()),
      TextEditingController(text: ''),
      TextEditingController(text: '')
    ]);
  }
}

void validateAndSaveCurrentWorkout(
    CurrentWorkout currentWorkout, DatabaseService databaseService, UserDB user, BuildContext context) {
  if (validateWorkoutSets(currentWorkout.exercises)) {
    final List<ExerciseSet> aux = removeEmptyExercises(currentWorkout.exercises);
    currentWorkout.exercises.clear();
    currentWorkout.exercises.addAll(aux);
    databaseService.addWorkoutToHistory(currentWorkout, user.uid, context, FirebaseService());
  }
}

void clearCurrentWorkout(CurrentWorkout currentWorkout, StopWatchTimer stopWatchTimer) {
  currentWorkout.exercises.clear();
  currentWorkout.startTime = null;
  currentWorkout.workoutName = TextEditingController(text: 'Daily workout');
  currentWorkout.workoutNotes = TextEditingController(text: 'Enter notes here...');
  currentWorkout.currentTimeInSeconds = 0;
  currentWorkout.lastDecrementForTimer = DateTime.now();
  currentWorkout.timer = null;
  if (stopWatchTimer.isRunning) {
    stopWatchTimer.dispose();
  }
}

void clearEditingTemplate(EditingTemplate editingTemplate) {
  editingTemplate.currentlyEditing = false;
  editingTemplate.editingTemplateId = null;
  editingTemplate.exercises.clear();
  editingTemplate.templateNotes = TextEditingController(text: 'Template Notes');
  editingTemplate.templateName = TextEditingController(text: 'Template Name');
}

void saveEditedTemplate(
    EditingTemplate editingTemplate, List<WorkoutTemplate> templates, String userUID, DatabaseService databaseService) {
  if (editingTemplate.exercises.isNotEmpty) {
    for (int i = 0; i < editingTemplate.exercises.length; i++) {
      final int? numberOfSets = int.tryParse(editingTemplate.exercises[i].sets[0][0].text);
      editingTemplate.exercises[i].sets.clear();
      for (int j = 0; j < numberOfSets!; j++) {
        editingTemplate.exercises[i].sets.add(<TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: '0')
        ]);
      }
    }
    if (editingTemplate.editingTemplateId == null) {
      const Uuid UID = Uuid();
      final String templateID = '${userUID}_${UID.v4()}';
      final WorkoutTemplate templateToAdd = WorkoutTemplate(
          editingTemplate.templateName.text, editingTemplate.templateNotes.text, editingTemplate.exercises, templateID);
      templates.add(templateToAdd);
      databaseService.addWorkoutTemplateToDB(templateToAdd, FirebaseService());
    } else {
      final String? templateID = editingTemplate.editingTemplateId;
      final WorkoutTemplate templateToAdd = WorkoutTemplate(editingTemplate.templateName.text,
          editingTemplate.templateNotes.text, editingTemplate.exercises, templateID!);
      templates.removeWhere((WorkoutTemplate element) => element.id == templateID);
      templates.add(templateToAdd);
      databaseService.addWorkoutTemplateToDB(templateToAdd, FirebaseService());
    }
  }
}

String convertTemplateToString(WorkoutTemplate workoutTemplate) {
  String returnText = '';
  try {
    returnText += '\n${workoutTemplate.name}\n';
    for (final ExerciseSet exerciseSet in workoutTemplate.exercises) {
      returnText += '\n\n';
      returnText += exerciseSet.assignedExercise.name;
      returnText += '\n  Sets: ${exerciseSet.sets.length} sets';
    }
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return returnText;
}

double differenceInSecondsAndMillisecondsBetweenTwoDateTimes(DateTime dateTime1, DateTime dateTime2) {
  final int seconds1 = dateTime1.second;
  final int milliseconds1 = dateTime1.millisecond;
  final int seconds2 = dateTime2.second;
  final int milliseconds2 = dateTime2.millisecond;
  final int total1 = seconds1 * 1000 + milliseconds1;
  final int total2 = seconds2 * 1000 + milliseconds2;
  return (total1 - total2) / 1000;
}
