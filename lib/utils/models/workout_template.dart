// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'exercise_set.dart';

class WorkoutTemplate {
  WorkoutTemplate(this.name, this.notes, List<ExerciseSet> exercisesReceived, this.id) {
    exercisesReceived.forEach((ExerciseSet element) {
      exercises.add(element);
    });
  }

  final String id;
  final String name;
  final String notes;
  final List<ExerciseSet> exercises = <ExerciseSet>[];
}
