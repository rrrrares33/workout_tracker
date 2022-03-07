import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../text/all_exercises_text.dart';
import 'padding.dart';
import 'text.dart';

class NoExerciseFound extends StatelessWidget {
  const NoExerciseFound({Key? key, required this.iconSize}) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.exclamationTriangle, size: iconSize),
            const PaddingWidget(type: 'symmetric', vertical: 15),
            const TextWidget(text: noExerciseFound, weight: FontWeight.bold),
            const PaddingWidget(type: 'symmetric', vertical: 10),
            const TextWidget(text: useOtherFilters1),
            const TextWidget(text: useOtherFilters2),
          ],
        ),
      ),
    );
  }
}
