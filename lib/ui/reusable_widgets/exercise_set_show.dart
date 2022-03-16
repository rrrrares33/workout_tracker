import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/models/exercise_set.dart';
import 'button.dart';
import 'exercise_full.dart';
import 'padding.dart';
import 'text.dart';

class ExerciseSetShow extends StatelessWidget {
  const ExerciseSetShow({Key? key, required this.screenWidth, required this.screenHeight, required this.setExercise})
      : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final ExerciseSet setExercise;

  @override
  Widget build(BuildContext context) {
    return PaddingWidget(
      type: 'symmetric',
      horizontal: screenWidth / 35,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: PaddingWidget(
                type: 'only',
                onlyLeft: screenWidth / 50,
                child: GestureDetector(
                  child: TextWidget(
                    align: TextAlign.start,
                    text: setExercise.assignedExercise.name,
                    weight: FontWeight.bold,
                    fontSize: screenWidth / 20,
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => ExerciseFull(
                      image: setExercise.assignedExercise.biggerImage,
                      name: setExercise.assignedExercise.name,
                      bodyPart: setExercise.assignedExercise.bodyPart,
                      category: setExercise.assignedExercise.category,
                      description: setExercise.assignedExercise.description,
                    ),
                  ),
                ),
              )),
              IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.ellipsisH))
            ],
          ),
          setExercise.getColumnHeaderRow(screenWidth),
          ButtonWidget(
            onPressed: () {},
            primaryColor: Colors.black54,
            minimumSize: Size.fromHeight(screenWidth / 15),
            text: const TextWidget(text: '+ Add another set'),
          )
        ],
      ),
    );
  }
}
