import 'package:flutter/material.dart';
import '../text/start_workout_text.dart';
import 'text.dart';

class AreYouSureWidget extends StatelessWidget {
  const AreYouSureWidget({Key? key, required this.width, required this.onChangedCancel}) : super(key: key);
  final double width;
  final void Function() onChangedCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(
        text: closeWorkoutTitle,
        fontSize: width/20,
        weight: FontWeight.bold,
      ),
      content: TextWidget(
        text: alertWindowCancelText,
        align: TextAlign.start,
        fontSize: width/25,
      ),
      alignment: Alignment.centerLeft,
      actions: <ElevatedButton>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          child: const TextWidget(text: abortCancelText),
        ),
        ElevatedButton(
          onPressed: onChangedCancel,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          child: const TextWidget(text: confirmCancelText),
        )
      ],
    );
  }
}
