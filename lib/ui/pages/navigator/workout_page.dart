import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import '../../../business_logic/workout_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/editing_template.dart';
import '../../../utils/models/exercise_set.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/workout_template.dart';
import '../../text/start_workout_text.dart';
import '../../widgets/alert_dialog_sure_to_close.dart';
import '../../widgets/alert_finish_workout.dart';
import '../../widgets/button.dart';
import '../../widgets/exercise_set_show.dart';
import '../../widgets/padding.dart';
import '../../widgets/text.dart';
import '../../widgets/timer_alert.dart';
import '../../widgets/workout_page_idle.dart';

const double expandedHeight = 50;
const double toolbarHeight = 40;

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({Key? key, required this.callback}) : super(key: key);
  final void Function(int) callback;

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  late ScrollController _scrollController;
  String? timerCurrentTime;
  String timeSinceStart = '';
  late StopWatchTimer stopWatchTimer;

  bool get _showBigLeftTitle {
    return _scrollController.hasClients && _scrollController.offset > expandedHeight - toolbarHeight;
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    try {
      // If not mounted, this throws errors.
      if (stopWatchTimer.isRunning) {
        stopWatchTimer.dispose();
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(context);
    final EditingTemplate editingTemplate = Provider.of<EditingTemplate>(context);
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final List<WorkoutTemplate> templates = Provider.of<List<WorkoutTemplate>>(context);
    final UserDB user = Provider.of<UserDB>(context);
    final Size screenSize = MediaQuery.of(context).size;

    if (currentWorkout.startTime == null && (editingTemplate.currentlyEditing ?? false) == false) {
      return WorkoutPageIdle(
        scrollController: _scrollController,
        height: screenSize.height,
        toolbarHeight: toolbarHeight,
        width: screenSize.width,
        showBigLeftTitle: _showBigLeftTitle,
        expandedHeight: expandedHeight,
        templates: templates,
        onPressedEditTemplate: (String templateId) {
          setState(() {
            editingTemplate.currentlyEditing = true;
            editingTemplate.editingTemplateId = templateId;
            final int indexOfTemplateToEdit =
                templates.indexWhere((WorkoutTemplate element) => element.id == templateId);
            editingTemplate.templateName = TextEditingController(text: templates[indexOfTemplateToEdit].name);
            editingTemplate.templateNotes = TextEditingController(text: templates[indexOfTemplateToEdit].notes);
            for (final ExerciseSet element in templates[indexOfTemplateToEdit].exercises) {
              late final ExerciseSet newExercise;
              if (element.type == 'ExerciseSetWeight') {
                newExercise = ExerciseSetWeight(element.assignedExercise);
                newExercise.type = 'ExerciseSetWeight';
              } else if (element.type == 'ExerciseSetMinusWeight') {
                newExercise = ExerciseSetMinusWeight(element.assignedExercise);
                newExercise.type = 'ExerciseSetMinusWeight';
              } else {
                newExercise = ExerciseSetDuration(element.assignedExercise);
                newExercise.type = 'ExerciseSetDuration';
              }
              editingTemplate.exercises.add(newExercise);
              final int nrOfSets = element.sets.length;
              editingTemplate.exercises[editingTemplate.exercises.length - 1].sets.add(<TextEditingController>[
                TextEditingController(text: nrOfSets.toString()),
                TextEditingController(text: ''),
                TextEditingController(text: '')
              ]);
            }
          });
        },
        onPressedDeleteTemplate: (String templateId) {
          final int indexToDelete = templates.indexWhere((WorkoutTemplate element) => element.id == templateId);
          databaseService.removeTemplate(templates[indexToDelete].id, FirebaseService());
          setState(() {
            templates.removeAt(indexToDelete);
          });
        },
        refreshPage: () {
          setState(() {
            widget.callback(3);
            widget.callback(2);
          });
        },
        onPressedStartEmpty: () {
          setState(() {
            currentWorkout.startTime = DateTime.now();
          });
        },
        onPressedTemplateEditing: () {
          setState(() {
            editingTemplate.currentlyEditing = true;
          });
        },
      );
    }
    if (currentWorkout.startTime != null) {
      // Starting the workout timer;
      stopWatchTimer = StopWatchTimer();
      if (!stopWatchTimer.isRunning) {
        stopWatchTimer.setPresetSecondTime(DateTime.now().difference(currentWorkout.startTime!).inSeconds);
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
        stopWatchTimer.execute;
      }
      return Scaffold(
          body: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leadingWidth: screenSize.width / 4.5,
            leading: PaddingWidget(
              type: 'only',
              onlyBottom: 4,
              onlyTop: 4,
              onlyLeft: 8,
              child: Align(
                child: SizedBox(
                  width: 100,
                  child: Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.greenAccent[400],
                    child: TimerWidget(
                      screenWidth: screenSize.width,
                      screenHeight: screenSize.height,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              PaddingWidget(
                type: 'all',
                all: screenSize.width / 50,
                child: ButtonWidget(
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext auxContext) => AlertFinishWorkout(
                            height: screenSize.height,
                            width: screenSize.width,
                            doesHaveUnCheckedSets: !checkForEmptySetsMultipleExercises(currentWorkout.exercises),
                            onPressedFinished: () async {
                              Navigator.pop(auxContext);
                              if (validateWorkoutSets(currentWorkout.exercises)) {
                                final List<ExerciseSet> aux = removeEmptyExercises(currentWorkout.exercises);
                                currentWorkout.exercises.clear();
                                currentWorkout.exercises.addAll(aux);
                                databaseService.addWorkoutToHistory(
                                    currentWorkout, user.uid, context, FirebaseService());
                              }
                              setState(() {
                                currentWorkout.exercises.clear();
                                currentWorkout.startTime = null;
                                currentWorkout.currentTimeInSeconds = 0;
                                currentWorkout.lastDecrementForTimer = DateTime.now();
                                currentWorkout.timer = null;
                                if (stopWatchTimer.isRunning) {
                                  stopWatchTimer.dispose();
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(workoutAddedToHistory);
                            },
                          )),
                  text: TextWidget(
                    text: finishText,
                    weight: FontWeight.bold,
                    fontSize: screenSize.width / 20,
                  ),
                  minimumSize: const Size.fromRadius(5),
                  primaryColor: Colors.greenAccent[400],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: PaddingWidget(
              type: 'only',
              onlyLeft: 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PaddingWidget(
                    type: 'only',
                    onlyTop: screenSize.height / 25,
                    onlyBottom: 5,
                    child: TextField(
                      onEditingComplete: () {
                        if (currentWorkout.workoutName.text == '') {
                          setState(() {
                            currentWorkout.workoutName.text = defaultWorkoutTile;
                          });
                        }
                      },
                      keyboardType: TextInputType.text,
                      controller: currentWorkout.workoutName,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: screenSize.width / 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StreamBuilder<int>(
                      stream: stopWatchTimer.secondTime,
                      initialData: 0,
                      builder: (BuildContext context, AsyncSnapshot<int> snap) {
                        final int? value = snap.data;
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          PaddingWidget(
                            type: 'only',
                            onlyLeft: 2,
                            child: TextWidget(
                              text: getPrintableTimerSinceStart(value.toString()),
                              fontSize: screenSize.width / 25,
                              color: Colors.grey,
                            ),
                          )
                        ]);
                      }),
                  PaddingWidget(
                      type: 'only',
                      onlyLeft: 2,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (_) {
                          setState(() {});
                        },
                        controller: currentWorkout.workoutNotes,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: currentWorkout.workoutNotes.text == defaultWorkoutNote ? Colors.grey : null,
                        ),
                      ))
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ExerciseSetShow(
                  setExercise: currentWorkout.exercises[index],
                  screenHeight: screenSize.height,
                  screenWidth: screenSize.width,
                  onPressedRemoveExercise: () {
                    setState(() {
                      currentWorkout.exercises.removeAt(index);
                    });
                  },
                  onPressedAddSet: () {
                    setState(() {
                      currentWorkout.exercises[index].addEmptySet();
                    });
                  },
                );
              },
              childCount: currentWorkout.exercises.length,
            ),
          ),
          SliverToBoxAdapter(
            child: PaddingWidget(
              type: 'only',
              onlyBottom: screenSize.height / 5,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Divider(
                      thickness: screenSize.height / 750,
                      color: currentWorkout.exercises.isNotEmpty ? null : Colors.transparent,
                      indent: screenSize.width / 35,
                      endIndent: screenSize.width / 35,
                    ),
                    PaddingWidget(
                      type: 'symmetric',
                      horizontal: screenSize.width / 35,
                      child: ButtonWidget(
                        onPressed: () {
                          setState(() {
                            widget.callback(3);
                            ScaffoldMessenger.of(context).showSnackBar(swipeRightAndPressToAddExercise);
                          });
                        },
                        text: TextWidget(
                          text: addANewExerciseToWorkout,
                          fontSize: screenSize.height / 45,
                        ),
                        primaryColor: Colors.greenAccent[400],
                        minimumSize: Size.fromHeight(screenSize.height / 25),
                      ),
                    ),
                    PaddingWidget(
                      type: 'symmetric',
                      horizontal: screenSize.width / 35,
                      child: ButtonWidget(
                        onPressed: () {
                          if (currentWorkout.exercises.isEmpty) {
                            // If there are no exercises added to the workout we can quickly stop it.
                            setState(() {
                              currentWorkout.workoutNotes = TextEditingController(text: defaultWorkoutNote);
                              currentWorkout.workoutName = TextEditingController(text: defaultWorkoutTile);
                              currentWorkout.startTime = null;
                              currentWorkout.currentTimeInSeconds = 0;
                              currentWorkout.lastDecrementForTimer = DateTime.now();
                              currentWorkout.timer = null;
                              if (stopWatchTimer.isRunning) {
                                stopWatchTimer.dispose();
                              }
                            });
                          } else {
                            showDialog<Widget>(
                              context: context,
                              builder: (BuildContext context) {
                                return AreYouSureWidget(
                                    width: screenSize.width,
                                    onPressedCancel: () {
                                      setState(() {
                                        currentWorkout.workoutNotes = TextEditingController(text: defaultWorkoutNote);
                                        currentWorkout.workoutName = TextEditingController(text: defaultWorkoutTile);
                                        currentWorkout.exercises.clear();
                                        currentWorkout.startTime = null;
                                        currentWorkout.currentTimeInSeconds = 0;
                                        currentWorkout.lastDecrementForTimer = DateTime.now();
                                        currentWorkout.timer = null;
                                        if (stopWatchTimer.isRunning) {
                                          stopWatchTimer.dispose();
                                        }
                                      });
                                      Navigator.pop(context);
                                    });
                              },
                            );
                          }
                        },
                        text: TextWidget(
                          text: cancelWorkout,
                          fontSize: screenSize.height / 45,
                        ),
                        primaryColor: Colors.redAccent,
                        minimumSize: Size.fromHeight(screenSize.height / 25),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ));
    }
    // we are editing a template if we reach this point
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, controller: _scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          leadingWidth: screenSize.width / 4,
          leading: PaddingWidget(
            type: 'all',
            all: screenSize.width / 50,
            child: ButtonWidget(
              onPressed: () {
                setState(() {
                  editingTemplate.currentlyEditing = false;
                  editingTemplate.exercises.clear();
                  editingTemplate.templateNotes = TextEditingController(text: 'Template Notes');
                  editingTemplate.templateName = TextEditingController(text: 'Template Name');
                });
              },
              text: TextWidget(
                text: 'Close',
                weight: FontWeight.bold,
                fontSize: screenSize.width / 20,
              ),
              minimumSize: const Size.fromRadius(5),
              primaryColor: Colors.redAccent,
            ),
          ),
          actions: <Widget>[
            PaddingWidget(
              type: 'all',
              all: screenSize.width / 50,
              child: ButtonWidget(
                onPressed: () {
                  if (editingTemplate.exercises.isNotEmpty) {
                    for (int i = 0; i < editingTemplate.exercises.length; i++) {
                      final int? numberOfSets = int.tryParse(editingTemplate.exercises[i].sets[0][0].text);
                      editingTemplate.exercises[i].sets.clear();
                      for (int j = 0; j < numberOfSets!; j++) {
                        editingTemplate.exercises[i].sets.add(<TextEditingController>[
                          TextEditingController(text: '0'),
                          TextEditingController(text: '0'),
                          TextEditingController(text: '0')
                        ]);
                      }
                    }
                    if (editingTemplate.editingTemplateId == null) {
                      const Uuid UID = Uuid();
                      final String templateID = '${user.uid}_${UID.v4()}';
                      final WorkoutTemplate templateToAdd = WorkoutTemplate(editingTemplate.templateName.text,
                          editingTemplate.templateNotes.text, editingTemplate.exercises, templateID);
                      templates.add(templateToAdd);
                      databaseService.addWorkoutTemplateToDB(templateToAdd, FirebaseService());
                    } else {
                      final String? templateID = editingTemplate.editingTemplateId;
                      final WorkoutTemplate templateToAdd = WorkoutTemplate(editingTemplate.templateName.text,
                          editingTemplate.templateNotes.text, editingTemplate.exercises, templateID!);
                      templates.removeWhere((WorkoutTemplate element) => element.id == templateID);
                      templates.add(templateToAdd);
                      databaseService.addWorkoutTemplateToDB(templateToAdd, FirebaseService());
                    }
                  }
                  setState(() {
                    editingTemplate.currentlyEditing = false;
                    editingTemplate.exercises.clear();
                    editingTemplate.templateNotes = TextEditingController(text: 'Template Notes');
                    editingTemplate.templateName = TextEditingController(text: 'Template Name');
                  });
                },
                text: TextWidget(
                  text: finishText,
                  weight: FontWeight.bold,
                  fontSize: screenSize.width / 20,
                ),
                minimumSize: const Size.fromRadius(5),
                primaryColor: Colors.greenAccent[400],
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
            child: PaddingWidget(
          type: 'only',
          onlyLeft: 17,
          child: Column(children: <Widget>[
            PaddingWidget(
              type: 'only',
              onlyTop: screenSize.height / 100,
              child: TextField(
                onEditingComplete: () {
                  if (editingTemplate.templateName.text == '') {
                    setState(() {
                      editingTemplate.templateName.text = 'Template Name';
                    });
                  }
                },
                maxLength: 15,
                keyboardType: TextInputType.text,
                controller: editingTemplate.templateName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                style: TextStyle(
                  fontSize: screenSize.width / 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (_) {
                setState(() {});
              },
              controller: editingTemplate.templateNotes,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: editingTemplate.templateNotes.text == 'Template Notes' ? Colors.black54 : null,
              ),
            )
          ]),
        )),
        SliverToBoxAdapter(
            child: PaddingWidget(
          type: 'symmetric',
          horizontal: screenSize.width / 20,
          vertical: screenSize.height / 50,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: screenSize.width / 5,
                    child: TextWidget(
                      text: 'Order',
                      weight: FontWeight.bold,
                      fontSize: screenSize.width / 25,
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 2.25,
                    child: TextWidget(
                      text: 'Exercise',
                      weight: FontWeight.bold,
                      fontSize: screenSize.width / 25,
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 4,
                    child: TextWidget(
                      text: 'Nr. Sets',
                      weight: FontWeight.bold,
                      fontSize: screenSize.width / 25,
                      align: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: screenSize.height / 750,
                color: editingTemplate.exercises.isNotEmpty ? null : Colors.transparent,
                indent: screenSize.width / 35,
                endIndent: screenSize.width / 35,
              ),
            ],
          ),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return PaddingWidget(
                  type: 'symmetric',
                  vertical: screenSize.height / 75,
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.14,
                      openThreshold: 0.05,
                      children: <Widget>[
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            setState(() {
                              editingTemplate.exercises.removeAt(index);
                            });
                          },
                          foregroundColor: Colors.redAccent,
                          icon: FontAwesomeIcons.circleXmark,
                          backgroundColor: Colors.transparent,
                          spacing: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screenSize.width / 5,
                          child: TextWidget(
                            text: (index + 1).toString(),
                            weight: FontWeight.bold,
                            fontSize: screenSize.width / 25,
                            align: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width / 2.25,
                          child: TextWidget(
                            text: editingTemplate.exercises[index].assignedExercise.name,
                            weight: FontWeight.bold,
                            fontSize: screenSize.width / 25,
                            align: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                            width: screenSize.width / 4,
                            child: PaddingWidget(
                                type: 'symmetric',
                                horizontal: screenSize.width / 100,
                                child: NumberInputPrefabbed.roundedButtons(
                                  controller: editingTemplate.exercises[index].sets[0][0],
                                  incDecBgColor: Colors.greenAccent,
                                  initialValue: int.tryParse(editingTemplate.exercises[index].sets[0][0].text) ?? 1,
                                  min: 1,
                                  max: 10,
                                  numberFieldDecoration: const InputDecoration(border: InputBorder.none),
                                  buttonArrangement: ButtonArrangement.incRightDecLeft,
                                ))),
                      ],
                    ),
                  ));
            },
            childCount: editingTemplate.exercises.length,
          ),
        ),
        SliverToBoxAdapter(
          child: PaddingWidget(
            type: 'only',
            onlyBottom: screenSize.height / 5,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Divider(
                    thickness: screenSize.height / 750,
                    color: currentWorkout.exercises.isNotEmpty ? null : Colors.transparent,
                    indent: screenSize.width / 35,
                    endIndent: screenSize.width / 35,
                  ),
                  PaddingWidget(
                    type: 'symmetric',
                    horizontal: screenSize.width / 35,
                    child: ButtonWidget(
                      onPressed: () {
                        setState(() {
                          widget.callback(3);
                          ScaffoldMessenger.of(context).showSnackBar(swipeRightAndPressToAddExercise);
                        });
                      },
                      text: TextWidget(
                        text: addANewExerciseToWorkout,
                        fontSize: screenSize.height / 45,
                      ),
                      primaryColor: Colors.greenAccent[400],
                      minimumSize: Size.fromHeight(screenSize.height / 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
