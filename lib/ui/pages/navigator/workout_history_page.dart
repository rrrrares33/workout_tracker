import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/workout_history_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/editing_template.dart';
import '../../../utils/models/exercise_set.dart';
import '../../../utils/models/history_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../text/start_workout_text.dart';
import '../../widgets/alert_history_workout.dart';
import '../../widgets/history_calendar.dart';
import '../../widgets/padding.dart';
import '../../widgets/sliver_top_bar.dart';
import '../../widgets/text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 35;

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({Key? key, required this.callback}) : super(key: key);
  final void Function(int) callback;

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  late ScrollController _scrollController;

  bool get _showBigLeftTitle {
    return _scrollController.hasClients && _scrollController.offset > expandedHeight - toolbarHeight;
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<HistoryWorkout> historyWorkouts = Provider.of<List<HistoryWorkout>>(context);
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(context);
    final EditingTemplate editingTemplate = Provider.of<EditingTemplate>(context);
    final UserDB user = Provider.of<UserDB>(context);
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverTopBar(
              expandedHeight: expandedHeight,
              toolbarHeight: toolbarHeight,
              textExpanded: 'Workouts History',
              textToolbar: 'Workouts History',
              actions: <Widget>[
                CalendarHistoryWorkouts(
                  height: screenSize.height,
                  width: screenSize.width,
                  workouts: getAllDateTimesOfWorkouts(historyWorkouts),
                ),
              ],
              showBigTitle: _showBigLeftTitle),
          if (historyWorkouts.isNotEmpty)
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return PaddingWidget(
                  type: 'symmetric',
                  horizontal: screenSize.width / 15,
                  child: PaddingWidget(
                    type: 'only',
                    onlyTop: screenSize.width / 25,
                    child: GestureDetector(
                      onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext auxContext) => ShowHistoryWorkoutFull(
                                workout: historyWorkouts[index],
                                width: screenSize.height,
                                height: screenSize.width,
                                user: user,
                              )),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: PaddingWidget(
                          type: 'all',
                          all: screenSize.width / 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PaddingWidget(
                                type: 'symmetric',
                                horizontal: screenSize.width / 55.5,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextWidget(
                                        text: historyWorkouts[index].workoutName,
                                        weight: FontWeight.bold,
                                        fontSize: screenSize.width / 20,
                                        align: TextAlign.left,
                                      ),
                                    ),
                                    PopupMenuButton<int>(
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuItem<int>>[
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  databaseService.removeWorkoutFromHistory(
                                                      historyWorkouts[index].id, FirebaseService());
                                                  setState(() {});
                                                },
                                                child: TextWidget(
                                                  text: 'Remove',
                                                  fontSize: screenSize.width / 23,
                                                  color: Colors.red,
                                                  weight: FontWeight.bold,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 2,
                                            child: Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  if ((editingTemplate.currentlyEditing == null ||
                                                          editingTemplate.currentlyEditing == false) &&
                                                      currentWorkout.startTime == null) {
                                                    setState(() {
                                                      currentWorkout.startTime = DateTime.now();
                                                      currentWorkout.workoutNotes = TextEditingController(
                                                          text: historyWorkouts[index].workoutNotes);
                                                      currentWorkout.workoutName = TextEditingController(
                                                          text: historyWorkouts[index].workoutName);
                                                      for (final ExerciseSet element
                                                          in historyWorkouts[index].exercises) {
                                                        late final ExerciseSet aux;
                                                        if (element.type == 'ExerciseSetWeight') {
                                                          aux = ExerciseSetWeight(element.assignedExercise);
                                                          aux.type = 'ExerciseSetWeight';
                                                        } else if (element.type == 'ExerciseSetMinusWeight') {
                                                          aux = ExerciseSetMinusWeight(element.assignedExercise);
                                                          aux.type = 'ExerciseSetMinusWeight';
                                                        } else {
                                                          aux = ExerciseSetDuration(element.assignedExercise);
                                                          aux.type = 'ExerciseSetDuration';
                                                        }
                                                        for (final List<TextEditingController> element2
                                                            in element.sets) {
                                                          final List<TextEditingController> damn = element2.toList();
                                                          damn.add(TextEditingController(text: notCheckedText));
                                                          aux.sets.add(damn);
                                                        }
                                                        currentWorkout.exercises.add(aux);
                                                      }
                                                      widget.callback(2);
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: TextWidget(
                                                  text: 'Start workout',
                                                  fontSize: screenSize.width / 23,
                                                  color: Colors.blue,
                                                  weight: FontWeight.bold,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 2,
                                            child: Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  if ((editingTemplate.currentlyEditing == null ||
                                                          editingTemplate.currentlyEditing == false) &&
                                                      currentWorkout.startTime == null) {
                                                    setState(() {
                                                      editingTemplate.templateNotes = TextEditingController(
                                                          text: historyWorkouts[index].workoutNotes);
                                                      editingTemplate.templateName = TextEditingController(
                                                          text: historyWorkouts[index].workoutName);
                                                      for (final ExerciseSet element
                                                          in historyWorkouts[index].exercises) {
                                                        late final ExerciseSet aux;
                                                        if (element.type == 'ExerciseSetWeight') {
                                                          aux = ExerciseSetWeight(element.assignedExercise);
                                                          aux.type = 'ExerciseSetWeight';
                                                        } else if (element.type == 'ExerciseSetMinusWeight') {
                                                          aux = ExerciseSetMinusWeight(element.assignedExercise);
                                                          aux.type = 'ExerciseSetMinusWeight';
                                                        } else {
                                                          aux = ExerciseSetDuration(element.assignedExercise);
                                                          aux.type = 'ExerciseSetDuration';
                                                        }
                                                        final List<TextEditingController> damn =
                                                            <TextEditingController>[
                                                          TextEditingController(text: element.sets.length.toString()),
                                                          TextEditingController(),
                                                          TextEditingController()
                                                        ];
                                                        aux.sets.add(damn);
                                                        editingTemplate.exercises.add(aux);
                                                      }
                                                      editingTemplate.currentlyEditing = true;
                                                      widget.callback(2);
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: TextWidget(
                                                  text: 'Save as template',
                                                  fontSize: screenSize.width / 23,
                                                  color: Colors.green,
                                                  weight: FontWeight.bold,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          )
                                        ];
                                      },
                                      icon: const Icon(FontAwesomeIcons.ellipsis),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              const PaddingWidget(
                                type: 'symmetric',
                                vertical: 2.0,
                              ),
                              PaddingWidget(
                                type: 'symmetric',
                                horizontal: screenSize.width / 55.5,
                                child: TextWidget(
                                  text: getDateAndTimeForPrinting(historyWorkouts[index].startTime!),
                                  fontSize: screenSize.width / 30,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const PaddingWidget(
                                type: 'symmetric',
                                vertical: 4.0,
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {}, icon: const Icon(Icons.timer), iconSize: screenSize.width / 20),
                                  TextWidget(
                                    text: getWorkoutLengthForPrinting(historyWorkouts[index].duration!),
                                    fontSize: screenSize.width / 30,
                                  ),
                                  PaddingWidget(type: 'symmetric', horizontal: screenSize.width / 9),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(FontAwesomeIcons.weightHanging),
                                      iconSize: screenSize.width / 20),
                                  TextWidget(
                                    text: getTotalWeightOfAnWorkout(
                                        historyWorkouts[index].exercises, user.weight!, user.weightType!),
                                    fontSize: screenSize.width / 30,
                                  ),
                                ],
                              ),
                              const PaddingWidget(
                                type: 'symmetric',
                                vertical: 2.0,
                              ),
                              Row(
                                children: <Widget>[
                                  PaddingWidget(
                                    type: 'symmetric',
                                    horizontal: screenSize.width / 55.5,
                                  ),
                                  SizedBox(
                                    width: screenSize.width / 2.25,
                                    height: screenSize.height / 50,
                                    child: TextWidget(
                                      text: 'Exercise',
                                      weight: FontWeight.bold,
                                      fontSize: screenSize.width / 27.5,
                                      align: TextAlign.left,
                                    ),
                                  ),
                                  TextWidget(
                                    text: 'Best Set',
                                    weight: FontWeight.bold,
                                    fontSize: screenSize.width / 27.5,
                                    align: TextAlign.left,
                                  ),
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.only(top: screenSize.height / 150),
                                  itemCount: historyWorkouts[index].exercises.length,
                                  itemBuilder: (BuildContext context, int exerciseIndex) {
                                    return PaddingWidget(
                                      type: 'only',
                                      onlyTop: screenSize.height / 200,
                                      child: Row(
                                        children: <Widget>[
                                          PaddingWidget(
                                            type: 'symmetric',
                                            horizontal: screenSize.width / 55.5,
                                          ),
                                          SizedBox(
                                            height: screenSize.height / 50,
                                            width: screenSize.width / 2.25,
                                            child: TextWidget(
                                              text:
                                                  '${historyWorkouts[index].exercises[exerciseIndex].sets.length} x ${reduceString(historyWorkouts[index].exercises[exerciseIndex].assignedExercise.name, screenSize.width ~/ 20)}',
                                              align: TextAlign.left,
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenSize.height / 50,
                                              width: screenSize.width / 3.5,
                                              child: TextWidget(
                                                text: getBestSet(historyWorkouts[index].exercises[exerciseIndex],
                                                    user.weight!, user.weightType!),
                                                align: TextAlign.left,
                                              )),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: historyWorkouts.length,
            ))
          else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.triangleExclamation, size: screenSize.width / 3),
                    PaddingWidget(type: 'symmetric', vertical: screenSize.width / 20),
                    const TextWidget(text: 'There is no workout in your history', weight: FontWeight.bold),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
