import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../business_logic/workout_history_logic.dart';
import '../../utils/models/history_workout.dart';
import '../../utils/models/user_database.dart';
import 'padding.dart';
import 'text.dart';

class ShowHistoryWorkoutFull extends StatelessWidget {
  const ShowHistoryWorkoutFull({
    Key? key,
    required this.width,
    required this.workout,
    required this.height,
    required this.user,
  }) : super(key: key);
  final HistoryWorkout workout;
  final double width;
  final double height;
  final UserDB user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
        scrollable: true,
        title: Column(
          children: <Widget>[
            TextWidget(
              text: workout.workoutName,
              fontSize: width / 40,
              weight: FontWeight.bold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextWidget(
                  text: '${getDateAndTimeForPrinting(workout.startTime!).replaceAll('  ', ' , ')} , ',
                  fontStyle: FontStyle.italic,
                  fontSize: width / 60,
                ),
                const PaddingWidget(
                  type: 'symmetric',
                  vertical: 20,
                ),
                TextWidget(
                  text: workout.startTime?.split(' ')[0],
                  fontStyle: FontStyle.italic,
                  fontSize: width / 60,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.timer),
                  iconSize: width / 50,
                  constraints: const BoxConstraints(),
                ),
                TextWidget(
                  text: getWorkoutLengthForPrinting(workout.duration!),
                  fontSize: width / 55,
                ),
                PaddingWidget(
                  type: 'symmetric',
                  horizontal: width / 100,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.weightHanging),
                  iconSize: width / 60,
                  constraints: const BoxConstraints(),
                ),
                TextWidget(
                  text: getTotalWeightOfAnWorkout(workout.exercises, user.weight!, user.weightType!),
                  fontSize: width / 55,
                ),
              ],
            ),
            const PaddingWidget(
              type: 'symmetric',
              vertical: 5,
            ),
            if (workout.workoutNotes! != 'Notes')
              TextWidget(
                text: workout.workoutNotes,
                align: TextAlign.start,
              ),
          ],
        ),
        content: PaddingWidget(
          type: 'only',
          onlyBottom: height / 100,
          child: SizedBox(
            width: width / 1.5,
            height: height,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext contextExercise, int indexExercise) {
                    return PaddingWidget(
                      type: 'only',
                      onlyTop: height / 50,
                      onlyBottom: height / 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: workout.exercises[indexExercise].assignedExercise.name,
                            fontSize: width / 55,
                            weight: FontWeight.bold,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: workout.exercises[indexExercise].sets.length,
                            itemBuilder: (BuildContext contextSet, int indexSet) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextWidget(text: '${indexSet + 1}.  '),
                                  if (workout.exercises[indexExercise].type == 'ExerciseSetDuration')
                                    TextWidget(text: '${workout.exercises[indexExercise].sets[indexSet][0].text} time.')
                                  else
                                    Row(
                                      children: <Widget>[
                                        if (workout.exercises[indexExercise].sets[indexSet][1].text != '0')
                                          TextWidget(
                                              text:
                                                  '${workout.exercises[indexExercise].sets[indexSet][1].text} kg.  x  '),
                                        TextWidget(
                                            text: '${workout.exercises[indexExercise].sets[indexSet][0].text} reps.')
                                      ],
                                    )
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                  childCount: workout.exercises.length,
                ))
              ],
            ),
          ),
        ));
  }
}
