// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'exercise_set.dart';

class HistoryWorkout {
  HistoryWorkout(this.startTime, this.workoutName, this.workoutNotes, List<ExerciseSet> exercises, this.duration) {
    exercises.forEach((ExerciseSet element) {
      this.exercises.add(element);
    });
  }

  final String? startTime;
  final String? duration;
  final String? workoutName;
  final String? workoutNotes;
  final List<ExerciseSet> exercises = <ExerciseSet>[];
}
