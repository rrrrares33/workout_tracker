// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/current_workout.dart';
import '../models/exercise.dart';
import '../models/exercise_set.dart';
import '../models/history_workout.dart';
import '../models/user_database.dart';
import '../models/workout_template.dart';
import 'firebase_service.dart';

class DatabaseService {
  DatabaseService();

  static List<UserDB> _allUsers = <UserDB>[];

  final List<Exercise> _allExercises = <Exercise>[];
  final List<HistoryWorkout> _workoutHistory = <HistoryWorkout>[];
  final List<WorkoutTemplate> _workoutTemplates = <WorkoutTemplate>[];

  List<UserDB> getUsers() {
    return _allUsers;
  }

  // Here I try to initialize everything from the database into the app,
  //  so it will be easier for the program to process everything without
  //  waiting times.
  Future<bool> loadUsers(FirebaseService firebaseService) async {
    // Starts loading database data.
    // print('Data started loading');
    _allUsers = await getAllUsers(firebaseService);
    // print('Data finished');
    return true;
  }

  // Gets all current users from database.
  // It is called only once at the start of the application.
  Future<List<UserDB>> getAllUsers(FirebaseService firebaseService) async {
    //This method should return all users store in the database.
    //If there is no user, it will return an empty list.
    final List<UserDB> users = <UserDB>[];
    final Map<dynamic, dynamic>? result = await firebaseService.getData('Users');
    if (result == null || result.isEmpty) {
      return <UserDB>[];
    }
    result.forEach((dynamic key, dynamic value) {
      value = value as Map<dynamic, dynamic>;
      final UserDB auxUser = UserDB.fromJson(value);
      users.add(auxUser);
    });
    return users;
  }

  // Gets an user using its uid. (provided by firebase_authentication).
  UserDB? getUserBaseOnUid(String uid) {
    UserDB? foundUser;
    bool found = false;
    for (final UserDB user in _allUsers) {
      if (user.uid == uid && found == false) {
        if (user.firstEntry == true) {
          foundUser = UserDB(user.uid, user.email, user.firstEntry);
          found = true;
        } else {
          foundUser = UserDB(user.uid, user.email, user.firstEntry, user.name, user.surname, user.age, user.weight,
              user.height, user.weightType);
          found = true;
        }
      }
    }
    return foundUser;
  }

  // Creates an user before completing the details form.
  Future<Map<String, dynamic>> createUserBeforeDetails(
      FirebaseService firebaseService, String uid, String email) async {
    _allUsers.add(UserDB(uid, email, true));
    final Map<String, dynamic> res = await firebaseService.createUserBeforeDetails(uid, email);
    return res;
  }

  // Creates an user after completing the details form.
  Future<Map<String, dynamic>> createUserWithFullDetails(String uid, String email, String name, String surname, int age,
      double weight, double height, WeightMetric weightType, FirebaseService firebaseService) async {
    // We first delete the already created user (firstEntry == true)
    await firebaseService.removeUserBasedOnUID(uid);

    final int posToRemove = _allUsers.lastIndexWhere((UserDB element) => element.uid == uid);
    _allUsers.removeAt(posToRemove);
    _allUsers.add(UserDB(uid, email, false, name, surname, age, weight, height, weightType));

    // Then we create the new user.
    final Map<String, dynamic> res =
        await firebaseService.createUserWithFullDetails(uid, email, name, surname, age, weight, height, weightType);
    return res;
  }

  Future<bool> updateUserWeight(FirebaseService firebaseService, String uid, double newWeight) async {
    final int pointer = _allUsers.indexWhere((UserDB element) => element.uid == uid);
    if (pointer == -1) {
      return false;
    }
    _allUsers[pointer].weight = newWeight;
    final bool? result = await firebaseService.changeUserWeight(uid, newWeight);
    return result!;
  }

  Future<bool> deleteAnUser(FirebaseService firebaseService, String uid) async {
    _allUsers.removeWhere((UserDB user) => user.uid == uid);
    return firebaseService.removeUserBasedOnUID(uid);
  }

  // Gets all exercises from the database which may be accessed by the current user.
  Future<List<Exercise>> getAllExercisesForUser(
      String uid, BuildContext? context, FirebaseService firebaseService) async {
    if (_allExercises.isEmpty) {
      try {
        final List<InternetAddress> result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final List<Exercise> finalList = await getAllExercisesFromDBForUser(uid, firebaseService);
          _allExercises.addAll(finalList);
        }
      } on SocketException catch (_) {
        return getAllExercisesFromJSONForUser(context!);
      }
    }
    return _allExercises;
  }

  Future<List<Exercise>> getAllExercisesFromJSONForUser(BuildContext context) async {
    final List<Exercise> exercises = <Exercise>[];

    final String data = await DefaultAssetBundle.of(context).loadString('assets/all_json_exercises.json');
    final Map<String, dynamic> allJsonExercises = jsonDecode(data) as Map<String, dynamic>;
    final Map<String, dynamic> allJsons = allJsonExercises['Exercises'] as Map<String, dynamic>;

    allJsons.forEach((String key, dynamic value) {
      final Exercise aux = Exercise.fromJson(value as Map<String, dynamic>);
      exercises.add(aux);
    });

    return exercises;
  }

  Future<List<Exercise>> getAllExercisesFromDBForUser(String uid, FirebaseService firebaseService) async {
    final List<Exercise> exercisesFromNet = <Exercise>[];
    final Map<dynamic, dynamic>? result = await firebaseService.getData('Exercises');
    if (result == null || result.isEmpty) {
      return <Exercise>[];
    }
    result.forEach((dynamic key, dynamic value) {
      value = value as Map<dynamic, dynamic>;
      final Exercise exercise = Exercise.fromJson(value);
      if (exercise.whoCreatedThisExercise == uid || exercise.whoCreatedThisExercise == 'system') {
        exercisesFromNet.add(exercise);
      }
    });
    return exercisesFromNet;
  }

  // Creates an user after completing the details form.
  Future<Map<String, dynamic>> createNewExercise(String userUid, String exerciseTitle, String? exerciseDescription,
      String exerciseCategory, String exerciseBodyType, FirebaseService firebaseService) async {
    final String idExercise = '${userUid}_$exerciseTitle';

    // Then we create the new user.
    final Map<String, dynamic> res = await firebaseService.createNewExercise(
        userUid, exerciseTitle, exerciseDescription, exerciseCategory, exerciseBodyType, idExercise);
    _allExercises.add(
        Exercise(exerciseTitle, exerciseDescription!, idExercise, userUid, exerciseCategory, exerciseBodyType, '', ''));
    return res;
  }

  Future<bool> deleteAnExercise(FirebaseService firebaseService, String exerciseID) async {
    _allExercises.removeWhere((Exercise element) => element.id == exerciseID);
    final bool? result = await firebaseService.removeExerciseBasedOnId(exerciseID);
    return result!;
  }

  Future<List<HistoryWorkout>> getAllHistoryFromDBForUser(
      String userUid, List<Exercise> exerciseList, FirebaseService firebaseService) async {
    if (_workoutHistory.isEmpty) {
      final List<HistoryWorkout> workoutHistory = <HistoryWorkout>[];
      final Map<dynamic, dynamic>? result = await firebaseService.getData('History');
      if (result == null || result.isEmpty) {
        return workoutHistory;
      }
      result.forEach((dynamic key, dynamic value) {
        value = value as Map<dynamic, dynamic>;
        key = key as String;
        if (key.contains(userUid)) {
          final String duration = value['duration'].toString();
          final String name = value['name'].toString();
          final String notes = value['notes'].toString();
          final List<String> splitDate = value['startTime'].toString().split('|')[0].split('-');
          final List<String> splitHour = value['startTime'].toString().split('|')[1].split('-');
          final String time = '${splitHour[0]}:${splitHour[1]}  ${splitDate[2]}.${splitDate[1]}.${splitDate[0]}';
          dynamic exercisesAndSets = value['exercisesAndSets'];
          exercisesAndSets = exercisesAndSets as Map<dynamic, dynamic>;
          final List<ExerciseSet> exercises = <ExerciseSet>[];
          final List<int?> indexOfEachExercise = <int>[];
          exercisesAndSets.forEach((dynamic key, dynamic value) {
            final List<String> splintedKey = (key as String).split('_');
            indexOfEachExercise.add(int.tryParse(splintedKey[0]));
            value = value as Map<dynamic, dynamic>;
            final String exerciseId = value['assignedExercise'].toString();
            final String type = value['type'].toString();
            final List<List<TextEditingController>> sets = <List<TextEditingController>>[];
            dynamic setsReceived = value['sets'];
            setsReceived = setsReceived as List<dynamic>;
            setsReceived.forEach((dynamic value) {
              if (value.toString() != 'null') {
                final TextEditingController firstController = TextEditingController();
                final TextEditingController secondController = TextEditingController();
                // Not Duration
                if (value.toString().contains('_')) {
                  firstController.text = value.toString().split('_')[0];
                  secondController.text = value.toString().split('_')[1];
                } else {
                  firstController.text = value.toString();
                  secondController.text = '0';
                }
                sets.add(<TextEditingController>[firstController, secondController]);
              }
            });
            late final ExerciseSet aux;
            if (type == 'ExerciseSetWeight') {
              exerciseList.forEach((Exercise element) {
                if (element.id == exerciseId) {
                  aux = ExerciseSetWeight(element);
                }
              });
            } else if (type == 'ExerciseSetDuration') {
              exerciseList.forEach((Exercise element) {
                if (element.id == exerciseId) {
                  aux = ExerciseSetDuration(element);
                }
              });
            } else {
              exerciseList.forEach((Exercise element) {
                if (element.id == exerciseId) {
                  aux = ExerciseSetMinusWeight(element);
                }
              });
            }
            aux.type = type;
            sets.forEach((List<TextEditingController> element) {
              aux.sets.add(element);
            });
            exercises.add(aux);
          });
          final List<ExerciseSet> sortedList = <ExerciseSet>[];
          for (int i = 0; i <= 100; i++) {
            final int pos = indexOfEachExercise.indexWhere((int? element) => element == i);
            if (pos != -1) {
              sortedList.add(exercises.removeAt(pos));
              indexOfEachExercise.removeAt(indexOfEachExercise.indexWhere((int? element) => element == i));
            }
          }
          exercises.clear();
          exercises.addAll(sortedList);
          final HistoryWorkout oneWorkout = HistoryWorkout(key, time, name, notes, exercises, duration);
          workoutHistory.add(oneWorkout);
        }
      });
      workoutHistory.sort((HistoryWorkout a, HistoryWorkout b) {
        final DateTime dateTimeA = DateFormat('HH:mm dd.MM.yyyy').parseLoose(a.startTime!);
        final DateTime dateTimeB = DateFormat('HH:mm dd.MM.yyyy').parseLoose(b.startTime!);
        return -dateTimeA.compareTo(dateTimeB);
      });
      _workoutHistory.addAll(workoutHistory);
    }
    return _workoutHistory;
  }

  Future<Map<String, dynamic>> addWorkoutToHistory(
      CurrentWorkout workoutToAdd, String userUid, BuildContext? context, FirebaseService firebaseService) async {
    final String startTime =
        '${workoutToAdd.startTime?.year}-${workoutToAdd.startTime?.month}-${workoutToAdd.startTime?.day}|${workoutToAdd.startTime?.hour}-${workoutToAdd.startTime?.minute}';
    final Duration duration = DateTime.now().difference(workoutToAdd.startTime!);
    late final String finalDuration;
    if (duration.inMinutes >= 60) {
      final String hours = (duration.inMinutes ~/ 60).toString();
      final num leftMinutes = duration.inMinutes - duration.inMinutes ~/ 60 * 60;
      if (leftMinutes >= 10) {
        finalDuration = '$hours:$leftMinutes';
      } else {
        finalDuration = '$hours:0$leftMinutes';
      }
    } else if (duration.inMinutes >= 10) {
      finalDuration = '00:${duration.inMinutes}';
    } else {
      finalDuration = '00:0${duration.inMinutes}';
    }

    final String idHistory = '${userUid}_$startTime';
    final HistoryWorkout workoutToAddToProvider = HistoryWorkout(idHistory, startTime, workoutToAdd.workoutName.text,
        workoutToAdd.workoutNotes.text, workoutToAdd.exercises, finalDuration);
    for (int i = 0; i < workoutToAdd.exercises.length; i += 1) {
      workoutToAdd.exercises[i].type = workoutToAdd.exercises[i].runtimeType.toString();
    }
    _workoutHistory.insert(0, workoutToAddToProvider);

    final Map<String, dynamic> exercisesAndSets = <String, dynamic>{};
    int index = 1;
    for (final ExerciseSet exercise in workoutToAdd.exercises) {
      final String idExercise = '${index}_${exercise.assignedExercise.id}';
      final Map<String, String> localSets = <String, String>{};
      int counter = 1;
      for (final List<TextEditingController> set in exercise.sets) {
        if (set[1].text.isNotEmpty) {
          localSets.putIfAbsent(counter.toString(), () => '${set[0].text}_${set[1].text}');
        } else {
          localSets.putIfAbsent(counter.toString(), () => set[0].text);
        }
        counter += 1;
      }
      exercisesAndSets.putIfAbsent(idExercise, () {
        final Map<String, dynamic> aux = <String, dynamic>{
          'type': exercise.runtimeType.toString(),
          'assignedExercise': exercise.assignedExercise.id,
          'sets': localSets,
        };
        return aux;
      });
      index += 1;
    }
    final Map<String, dynamic> res = await firebaseService.addWorkoutToHistory(workoutToAdd.workoutName.text,
        workoutToAdd.workoutNotes.text, startTime, finalDuration, exercisesAndSets, idHistory);
    return res;
  }

  Future<bool> removeWorkoutFromHistory(String historyWorkoutId, FirebaseService firebaseService) async {
    _workoutHistory.removeWhere((HistoryWorkout element) => element.id == historyWorkoutId);
    await firebaseService.removeHistory(historyWorkoutId);
    return true;
  }

  List<HistoryWorkout> getCurrentHistory() {
    return _workoutHistory;
  }

  Future<Future<Map<String, dynamic>>> addWorkoutTemplateToDB(
      WorkoutTemplate template, FirebaseService firebaseService) async {
    _workoutTemplates.add(template);
    final String templateNotes = template.notes;
    final String templateName = template.name;

    final Map<String, dynamic> exercisesAndSets = <String, dynamic>{};
    int index = 0;
    template.exercises.forEach((ExerciseSet element) {
      index += 1;
      final Map<String, List<String>> sets = <String, List<String>>{};
      int auxIndex = 0;
      element.sets.forEach((List<TextEditingController> element) {
        sets[auxIndex.toString()] = <String>['0', '0', '0'];
        auxIndex += 1;
      });
      final Map<String, dynamic> aux = <String, dynamic>{
        'type': element.runtimeType.toString(),
        'assignedExercise': element.assignedExercise.id,
        'sets': sets,
      };
      exercisesAndSets['${index}_${element.assignedExercise.id}'] = aux;
    });
    final Future<Map<String, dynamic>> res =
        firebaseService.addWorkoutTemplate(template.id, templateName, templateNotes, exercisesAndSets);
    return res;
  }

  Future<List<WorkoutTemplate>> getAllWorkoutTemplatesFromDBForUser(
      String userUid, List<Exercise> exerciseList, FirebaseService firebaseService) async {
    final List<WorkoutTemplate> workoutTemplates = <WorkoutTemplate>[];

    final Map<dynamic, dynamic>? result = await firebaseService.getData('Templates');
    if (result == null || result.isEmpty) {
      return workoutTemplates;
    }
    result.forEach((dynamic key, dynamic value) {
      value = value as Map<dynamic, dynamic>;
      key = key as String;
      try {
        if (key.contains(userUid) || key.contains('system')) {
          final String templateName = value['name'] as String;
          final String templateNotes = value['notes'] as String;
          final List<ExerciseSet> templateExercises = <ExerciseSet>[];
          final Map<dynamic, dynamic> allExercisesOfTemplate = value['exercises'] as Map<dynamic, dynamic>;
          final List<int?> indexOfEachExercise = <int>[];
          allExercisesOfTemplate.forEach((dynamic key, dynamic value) {
            final List<String> keyParsed = (key as String).split('_');
            indexOfEachExercise.add(int.tryParse(keyParsed[0]));
            final String exerciseId = '${keyParsed[1]}_${keyParsed[2]}';
            late final ExerciseSet currentSet;
            exerciseList.forEach((Exercise element) {
              if (exerciseId == element.id) {
                if (element.category == 'Assisted Bodyweight') {
                  currentSet = ExerciseSetMinusWeight(element);
                  currentSet.type = 'ExerciseSetMinusWeight';
                } else if (element.category == 'Time') {
                  currentSet = ExerciseSetDuration(element);
                  currentSet.type = 'ExerciseSetDuration';
                } else {
                  currentSet = ExerciseSetWeight(element);
                  currentSet.type = 'ExerciseSetWeight';
                }
              }
            });
            // ignore: avoid_dynamic_calls
            (value['sets'] as List<dynamic>).forEach((dynamic element) {
              currentSet.sets.add(<TextEditingController>[
                TextEditingController(text: '0'),
                TextEditingController(text: '0'),
                TextEditingController(text: 'unchecked')
              ]);
            });
            templateExercises.add(currentSet);
          });
          final List<ExerciseSet> sortedList = <ExerciseSet>[];
          for (int i = 0; i <= 100; i++) {
            final int pos = indexOfEachExercise.indexWhere((int? element) => element == i);
            if (pos != -1) {
              sortedList.add(templateExercises.removeAt(pos));
              indexOfEachExercise.removeAt(indexOfEachExercise.indexWhere((int? element) => element == i));
            }
          }
          templateExercises.clear();
          templateExercises.addAll(sortedList);
          final WorkoutTemplate currentWorkoutTemplate =
              WorkoutTemplate(templateName, templateNotes, templateExercises, key);
          workoutTemplates.add(currentWorkoutTemplate);
        }
      } on Exception catch (_) {}
    });
    _workoutTemplates.addAll(workoutTemplates);
    return workoutTemplates;
  }

  Future<bool> removeTemplate(String templateId, FirebaseService firebaseService) async {
    _workoutTemplates.removeWhere((WorkoutTemplate element) => element.id == templateId);
    await firebaseService.removeTemplate(templateId);
    return true;
  }

  List<WorkoutTemplate> getWorkoutTemplates() {
    return _workoutTemplates;
  }
}
