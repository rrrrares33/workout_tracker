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
  final DatabaseReference _weightTracker = FirebaseDatabase.instance.ref().child('WeightTracker');

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
        case 'WeightTracker':
          event = await _weightTracker.once();
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

  Future<Map<String, dynamic>> createUserBeforeDetails(String uid, String email) async {
    await _usersRef.child(uid).set(<String, dynamic>{'uid': uid, 'email': email, 'firstEntry': true.toString()});
    return <String, dynamic>{'uid': uid, 'email': email, 'firstEntry': true.toString()};
  }

  Future<bool> removeUserBasedOnUID(String uid) async {
    await _usersRef.child(uid).remove();
    return true;
  }

  Future<Map<String, dynamic>> createUserWithFullDetails(String uid, String email, String name, String surname,
      String sex, int age, double weight, double height, WeightMetric weightType) async {
    await _usersRef.child(uid).set(<String, dynamic>{
      'uid': uid,
      'email': email,
      'firstEntry': false.toString(),
      'name': name,
      'surname': surname,
      'sex': sex,
      'age': age.toString(),
      'weight': weight.toString(),
      'height': height.toString(),
      'weightType': weightType.toString()
    });
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'firstEntry': false.toString(),
      'name': name,
      'surname': surname,
      'sex': sex,
      'age': age.toString(),
      'weight': weight.toString(),
      'height': height.toString(),
      'weightType': weightType.toString()
    };
  }

  Future<bool?> changeUserWeight(String uid, double newWeight) async {
    final String pathToSearchForUid = '-Users/-$uid';
    try {
      await FirebaseDatabase.instance.ref(pathToSearchForUid).update(<String, String>{'weight': newWeight.toString()});
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> createNewExercise(String userUid, String exerciseTitle, String? exerciseDescription,
      String exerciseCategory, String exerciseBodyType, String idExercise) async {
    await _exercisesRef.child(idExercise).set(<String, dynamic>{
      'name': exerciseTitle,
      'description': exerciseDescription,
      'id': idExercise,
      'whoCreatedThisExercise': userUid,
      'category': exerciseCategory,
      'bodyPart': exerciseBodyType,
      'icon': '',
      'biggerImage': '',
      'exerciseVideo': '',
      'difficulty': 'Not assigned'
    });
    return <String, dynamic>{
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
    };
  }

  Future<bool?> removeExerciseBasedOnId(String exerciseID) async {
    try {
      await _exercisesRef.child(exerciseID).remove();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> addWorkoutToHistory(String name, String notes, String startTime, String finalDuration,
      Map<String, dynamic> exercisesAndSets, String idHistory) async {
    await _historyRef.child(idHistory).set(<String, dynamic>{
      'name': name,
      'notes': notes,
      'startTime': startTime,
      'duration': finalDuration,
      'exercisesAndSets': exercisesAndSets,
    });
    return <String, dynamic>{
      'name': name,
      'notes': notes,
      'startTime': startTime,
      'duration': finalDuration,
      'exercisesAndSets': exercisesAndSets,
    };
  }

  Future<bool> removeHistory(String historyID) async {
    try {
      await _historyRef.child(historyID).remove();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> removeExerciseFromHistory(String historyId, String idOfExercise) async {
    try {
      for (int i = 0; i < 15; i++) {
        await _historyRef.child(historyId).child('exercisesAndSets').child('${i}_$idOfExercise').remove();
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> addWorkoutTemplate(
      String templateID, String templateName, String templateNotes, Map<String, dynamic> exercisesAndSets) async {
    await _templateRef.child(templateID).set(<String, dynamic>{
      'name': templateName,
      'notes': templateNotes,
      'exercises': exercisesAndSets,
    });
    return <String, dynamic>{
      'name': templateName,
      'notes': templateNotes,
      'exercises': exercisesAndSets,
    };
  }

  Future<bool> removeTemplate(String templateId) async {
    try {
      await _templateRef.child(templateId).remove();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> addWeightTrackerForUser(String uid, double? weight, DateTime datetime) async {
    await _weightTracker.child(uid).set(<String, dynamic>{
      'uid': uid,
      'weights': <double>[weight!].toString(),
      'dates': <String>['${datetime.day}-${datetime.month}-${datetime.year}'].toString(),
    });
    return true;
  }

  Future<bool> removeTracker(String uid) async {
    await _weightTracker.child(uid).remove();
    return true;
  }

  Future<bool> updateTracker(String uid, String weights, String dates) async {
    await _weightTracker.child(uid).set(<String, dynamic>{
      'uid': uid,
      'weights': weights,
      'dates': dates,
    });
    return true;
  }
}
