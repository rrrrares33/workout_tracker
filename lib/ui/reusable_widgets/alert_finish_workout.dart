import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../text/start_workout_text.dart';
import 'button.dart';
import 'padding.dart';
import 'text.dart';

class AlertFinishWorkout extends StatelessWidget {
  const AlertFinishWorkout(
      {Key? key,
      required this.width,
      required this.onPressedFinished,
      required this.height,
      required this.doesHaveUnCheckedSets})
      : super(key: key);
  final double width;
  final double height;
  final bool doesHaveUnCheckedSets;
  final void Function() onPressedFinished;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
      alignment: Alignment.centerLeft,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(FontAwesomeIcons.fontAwesomeFlag),
          PaddingWidget(
            type: 'symmetric',
            horizontal: width / 20,
            child: TextWidget(
              text: finishWorkoutTitle,
              fontSize: width / 20,
              weight: FontWeight.bold,
            ),
          ),
          const Icon(FontAwesomeIcons.fontAwesomeFlag),
        ],
      ),
      content: doesHaveUnCheckedSets ? null : const TextWidget(text: notCheckedExercisesPart, color: Colors.redAccent),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ButtonWidget(
          onPressed: () {
            Navigator.pop(context);
          },
          text: const TextWidget(text: resumeWorkout),
          primaryColor: Colors.blueGrey,
        ),
        ButtonWidget(onPressed: onPressedFinished, text: const TextWidget(text: finishWorkoutConfirmation))
      ],
    );
  }
}
