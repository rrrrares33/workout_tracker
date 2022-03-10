import 'exercise.dart';

class ExerciseSet {
  ExerciseSet(this._assignedExercise);

  final Exercise _assignedExercise;

  Exercise getAssignedExercise() {
    return _assignedExercise;
  }

  String getExerciseCategory() {
    return _assignedExercise.category;
  }

  final List<dynamic> _sets = <dynamic>[];

  void addANewSet(dynamic aux) {
    _sets.add(aux);
  }

  List<dynamic> getAllSets() {
    return _sets;
  }
}
