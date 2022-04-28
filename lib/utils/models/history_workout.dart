// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'exercise_set.dart';

class HistoryWorkout {
  HistoryWorkout(
      this.id, this.startTime, this.workoutName, this.workoutNotes, List<ExerciseSet> exercises, this.duration) {
    if (startTime!.contains('|')) {
      // Because startTime has format for storing into DB, we need to remake it for easier display
      final List<String> splitDate = startTime.toString().split('|')[0].split('-');
      final List<String> splitHour = startTime.toString().split('|')[1].split('-');
      startTime = '${splitHour[0]}:${splitHour[1]}  ${splitDate[2]}.${splitDate[1]}.${splitDate[0]}';
    }
    // Also we should save each exercise here before closing a current workout
    exercises.forEach((ExerciseSet element) {
      this.exercises.add(element);
    });
  }

  final String id;
  // Start dd.mm.yyyy and hour:minutes:seconds of a workout
  String? startTime;
  // How much time did the workout took
  final String? duration;
  // Workout's name
  final String? workoutName;
  // Workout's notes
  final String? workoutNotes;
  // Exercises inside the workout
  final List<ExerciseSet> exercises = <ExerciseSet>[];
}
