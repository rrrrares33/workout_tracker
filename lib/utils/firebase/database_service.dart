import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../models/exercise.dart';
import '../models/user_database.dart';

class DatabaseService {
  DatabaseService() {
    _firebaseDB = FirebaseDatabase.instance;
    _usersRef = _firebaseDB.ref().child('Users');
    _exercisesRef = _firebaseDB.ref().child('Exercises');
  }

  // Here I try to initialize everything from the database into the app,
  //  so it will be easier for the program to process everything without
  //  waiting times.
  Future<bool> loadUsers() async {
    // Starts loading database data.
    // print('Data started loading');
    _allUsers = await getAllUsers();
    // print('Data finished');
    return true;
  }

  // We store the instance of the database in a private param.
  late final FirebaseDatabase _firebaseDB;
  late final DatabaseReference _usersRef;
  late final DatabaseReference _exercisesRef;

  List<UserDB> _allUsers = <UserDB>[];
  final List<Exercise> _allExercises = <Exercise>[];

  List<UserDB> getUsers() {
    return _allUsers;
  }

  // Gets all current users from database.
  // It is called only once at the start of the application.
  Future<List<UserDB>> getAllUsers() async {
    //This method should return all users store in the database.
    //If there is no user, it will return an empty list.
    final List<UserDB> users = <UserDB>[];
    final DatabaseEvent event = await _usersRef.once();
    if (event.snapshot.value == null) {
      return <UserDB>[];
    }
    final Map<dynamic, dynamic> result = event.snapshot.value! as Map<dynamic, dynamic>;
    if (result.isEmpty) {
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
  Future<void> createUserBeforeDetails(String uid, String email) async {
    await _usersRef.child(uid).set(<String, dynamic>{'uid': uid, 'email': email, 'firstEntry': true.toString()});
  }

  // Creates an user after completing the details form.
  Future<void> createUserWithFullDetails(String uid, String email, String name, String surname, int age, double weight,
      double height, WeightMetric weightType) async {
    // We first delete the already created user (firstEntry == true)
    await _usersRef.child(uid).remove();

    // Then we create the new user.
    await _usersRef.child(uid).set(<String, dynamic>{
      'uid': uid,
      'email': email,
      'firstEntry': false.toString(),
      'name': name,
      'surname': surname,
      'age': age.toString(),
      'weight': weight.toString(),
      'height': height.toString(),
      'weightType': weightType.toString()
    });
  }

  // Gets all exercises from the database which may be accessed by the current user.
  Future<List<Exercise>> getAllExercisesForUser(String uid, BuildContext context) async {
    if (_allExercises.isEmpty) {
      try {
        final List<InternetAddress> result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return getAllExercisesFromDBForUser(uid);
        }
      } on SocketException catch (_) {
        return getAllExercisesFromJSONForUser(context);
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

  Future<List<Exercise>> getAllExercisesFromDBForUser(String uid) async {
    final List<Exercise> exercisesFromNet = <Exercise>[];
    final DatabaseEvent event = await _exercisesRef.once();
    if (event.snapshot.value == null) {
      return <Exercise>[];
    }
    final Map<dynamic, dynamic> result = event.snapshot.value! as Map<dynamic, dynamic>;
    if (result.isEmpty) {
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
  Future<void> createNewExercise(String userUid, String exerciseTitle, String? exerciseDescription,
      String exerciseCategory, String exerciseBodyType) async {
    final String idExercise = '${userUid}_$exerciseTitle';

    // Then we create the new user.
    await _exercisesRef.child(idExercise).set(<String, dynamic>{
      'name': exerciseTitle,
      'description': exerciseDescription,
      'id': idExercise,
      'whoCreatedThisExercise': userUid,
      'category': exerciseCategory,
      'bodyPart': exerciseBodyType,
      'icon': 'userCreatedNoIcon',
      'biggerImage': 'userCreatedNoIcon',
      'exerciseVideo': 'userCreatedNoVideo',
      'difficulty': 'Not assigned'
    });
  }
}
