import 'package:firebase_database/firebase_database.dart';

import '../models/user_database.dart';

class FirebaseService {
  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  static final FirebaseService _instance = FirebaseService._internal();

  // We store the instance of the database in a private param.
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('Users');
  final DatabaseReference _exercisesRef = FirebaseDatabase.instance.ref().child('Exercises');
  final DatabaseReference _historyRef = FirebaseDatabase.instance.ref().child('History');
  final DatabaseReference _templateRef = FirebaseDatabase.instance.ref().child('Templates');

  Future<Map<dynamic, dynamic>?> getData(String dataType) async {
    try {
      DatabaseEvent? event;
      switch (dataType) {
        case 'Users':
          event = await _usersRef.once();
          break;
        case 'Exercises':
          event = await _exercisesRef.once();
          break;
        case 'History':
          event = await _historyRef.once();
          break;
        case 'Templates':
          event = await _templateRef.once();
          break;
      }
      if (event != null) {
        return event.snapshot.value as Map<dynamic, dynamic>?;
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> createUserBeforeDetails(String uid, String email) async {
    await _usersRef.child(uid).set(<String, dynamic>{'uid': uid, 'email': email, 'firstEntry': true.toString()});
  }

  Future<void> removeUserBasedOnUID(String uid) async {
    await _usersRef.child(uid).remove();
  }

  Future<void> createUserWithFullDetails(String uid, String email, String name, String surname, int age, double weight,
      double height, WeightMetric weightType) async {
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

  Future<void> createNewExercise(String userUid, String exerciseTitle, String? exerciseDescription,
      String exerciseCategory, String exerciseBodyType, String idExercise) async {
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

  Future<void> addWorkoutToHistory(String name, String notes, String startTime, String finalDuration,
      Map<String, dynamic> exercisesAndSets, String idHistory) async {
    await _historyRef.child(idHistory).set(<String, dynamic>{
      'name': name,
      'notes': notes,
      'startTime': startTime,
      'duration': finalDuration,
      'exercisesAndSets': exercisesAndSets,
    });
  }

  Future<void> addWorkoutTemplate(
      String templateID, String templateName, String templateNotes, Map<String, dynamic> exercisesAndSets) async {
    await _templateRef.child(templateID).set(<String, dynamic>{
      'name': templateName,
      'notes': templateNotes,
      'exercises': exercisesAndSets,
    });
  }
}
