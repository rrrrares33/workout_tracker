import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../business_logic/start_workout_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../reusable_widgets/alert_dialog_sure_to_close.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/exercise_set_show.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/sliver_top_bar.dart';
import '../../reusable_widgets/text.dart';
import '../../reusable_widgets/timer_alert.dart';
import '../../text/start_workout_text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 25;

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
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final UserDB user = Provider.of<UserDB>(context);
    final Size screenSize = MediaQuery.of(context).size;

    if (currentWorkout.startTime == null) {
      return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverTopBar(
                expandedHeight: expandedHeight,
                toolbarHeight: toolbarHeight,
                textExpanded: startWorkout,
                textToolbar: startWorkout,
                leading: Container(),
                showBigTitle: _showBigLeftTitle),
            SliverToBoxAdapter(
              child: PaddingWidget(
                type: 'symmetric',
                vertical: screenSize.height / 50,
                horizontal: screenSize.width / 30,
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PaddingWidget(
                        type: 'only',
                        onlyLeft: 17,
                        onlyTop: screenSize.height / 50,
                        child: TextWidget(
                          text: quickStart,
                          weight: FontWeight.bold,
                          fontSize: screenSize.width / 22,
                        ),
                      ),
                      PaddingWidget(
                        type: 'symmetric',
                        horizontal: 17,
                        vertical: 13.5,
                        child: ButtonWidget(
                          text: TextWidget(
                            text: startEmptyWorkout,
                            weight: FontWeight.bold,
                            fontSize: screenSize.width / 25,
                          ),
                          primaryColor: Colors.greenAccent[400],
                          onPressed: () {
                            setState(() {
                              currentWorkout.startTime = DateTime.now();
                            });
                          },
                          minimumSize: Size.fromHeight(screenSize.height / 17.5),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
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
                  onPressed: () async {
                    if (currentWorkout.exercises.isNotEmpty) {
                      databaseService.addWorkoutToHistory(currentWorkout, user.uid, context);
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
                          color: currentWorkout.workoutNotes.text == defaultWorkoutNote ? Colors.black54 : null,
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
                                    onChangedCancel: () {
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
  }
}
