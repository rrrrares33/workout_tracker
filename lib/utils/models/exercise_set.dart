import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../ui/reusable_widgets/padding.dart';
import '../../ui/reusable_widgets/text.dart';
import 'exercise.dart';

abstract class ExerciseSet {
  ExerciseSet(this.assignedExercise);

  String? type;
  final Exercise assignedExercise;
  final List<dynamic> sets = <dynamic>[];
  Widget getColumnHeaderRow(double screenWidth);
  Widget getSetRow();
}

class ExerciseSetDuration extends ExerciseSet {
  ExerciseSetDuration(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
        PaddingWidget(
          type: 'symmetric',
          horizontal: screenWidth / 3.5,
          child: const TextWidget(text: 'Duration', weight: FontWeight.bold),
        ),
        Icon(FontAwesomeIcons.check, size: screenWidth / 30),
      ],
    );
  }

  @override
  Widget getSetRow() {
    return Container();
  }
}

class ExerciseSetWeight extends ExerciseSet {
  ExerciseSetWeight(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return PaddingWidget(
      type: 'symmetric',
      horizontal: screenWidth / 50,
      child: Row(
        children: <Widget>[
          const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
          PaddingWidget(
            type: 'symmetric',
            horizontal: screenWidth / 6,
            child: const TextWidget(text: 'KG', weight: FontWeight.bold),
          ),
          PaddingWidget(
            type: 'only',
            onlyLeft: screenWidth / 10,
            onlyRight: screenWidth / 6,
            child: const TextWidget(text: 'Reps', weight: FontWeight.bold),
          ),
          Icon(FontAwesomeIcons.check, size: screenWidth / 30),
        ],
      ),
    );
  }

  @override
  Widget getSetRow() {
    return Container();
  }
}

class ExerciseSetMinusWeight extends ExerciseSet {
  ExerciseSetMinusWeight(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
        PaddingWidget(
          type: 'symmetric',
          horizontal: screenWidth / 6,
          child: const TextWidget(text: '-KG', weight: FontWeight.bold),
        ),
        PaddingWidget(
          type: 'only',
          onlyLeft: screenWidth / 10,
          onlyRight: screenWidth / 6,
          child: const TextWidget(text: 'Reps', weight: FontWeight.bold),
        ),
        Icon(FontAwesomeIcons.check, size: screenWidth / 30),
      ],
    );
  }

  @override
  Widget getSetRow() {
    return Container();
  }
}
