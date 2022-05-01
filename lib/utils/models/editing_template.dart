import 'package:flutter/cupertino.dart';

import 'exercise_set.dart';

class EditingTemplate {
  EditingTemplate() {
    templateNotes.text = 'Template notes';
    templateName.text = 'Template name';
    currentlyEditing = false;
  }

  // Template id - only when editing an already created template
  String? editingTemplateId;

  // Workout name
  TextEditingController templateName = TextEditingController();

  // Workout notes
  TextEditingController templateNotes = TextEditingController();

  // Exercises that were performed during the workout
  final List<ExerciseSet> exercises = <ExerciseSet>[];

  // Keeps track of whether we are working on a template or not
  bool? currentlyEditing;
}
