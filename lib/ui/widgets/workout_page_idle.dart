import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/models/current_workout.dart';
import '../../utils/models/exercise_set.dart';
import '../../utils/models/workout_template.dart';
import '../text/start_workout_text.dart';
import 'button.dart';
import 'padding.dart';
import 'sliver_top_bar.dart';
import 'text.dart';

class WorkoutPageIdle extends StatefulWidget {
  const WorkoutPageIdle({
    Key? key,
    required this.scrollController,
    required this.toolbarHeight,
    required this.expandedHeight,
    required this.showBigLeftTitle,
    required this.width,
    required this.height,
    required this.templates,
    this.onPressedStartEmpty,
    this.onPressedTemplateEditing,
    this.onPressedDeleteTemplate,
    this.refreshPage,
    this.onPressedEditTemplate,
  }) : super(key: key);
  final ScrollController scrollController;
  final double toolbarHeight;
  final double expandedHeight;
  final bool showBigLeftTitle;
  final double width;
  final double height;
  final List<WorkoutTemplate> templates;
  final void Function(String)? onPressedDeleteTemplate;
  final void Function(String)? onPressedEditTemplate;
  final VoidCallback? refreshPage;
  final VoidCallback? onPressedStartEmpty;
  final VoidCallback? onPressedTemplateEditing;

  @override
  State<WorkoutPageIdle> createState() => _WorkoutPageIdleState();
}

class _WorkoutPageIdleState extends State<WorkoutPageIdle> {
  bool hideSystemTemplates = false;

  @override
  Widget build(BuildContext context) {
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(context);
    final List<WorkoutTemplate> systemTemplates =
        widget.templates.where((WorkoutTemplate element) => element.name.contains('system')).toList();
    final List<WorkoutTemplate> personalTemplates =
        widget.templates.where((WorkoutTemplate element) => !element.name.contains('system')).toList();
    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          SliverTopBar(
              expandedHeight: widget.expandedHeight,
              toolbarHeight: widget.toolbarHeight,
              textExpanded: startWorkout,
              textToolbar: startWorkout,
              leading: Container(),
              showBigTitle: widget.showBigLeftTitle),
          SliverToBoxAdapter(
            child: PaddingWidget(
              type: 'only',
              onlyRight: widget.width / 30,
              onlyLeft: widget.width / 30,
              onlyTop: widget.height / 50,
              child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PaddingWidget(
                      type: 'only',
                      onlyLeft: 17,
                      onlyTop: widget.height / 50,
                      child: TextWidget(
                        text: quickStart,
                        weight: FontWeight.bold,
                        fontSize: widget.width / 22,
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
                          fontSize: widget.width / 25,
                        ),
                        primaryColor: Colors.greenAccent[400],
                        onPressed: widget.onPressedStartEmpty,
                        minimumSize: Size.fromHeight(widget.height / 17.5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: PaddingWidget(
            type: 'symmetric',
            vertical: widget.height / 50,
            horizontal: widget.width / 30,
            child: Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      PaddingWidget(
                        type: 'only',
                        onlyLeft: 17,
                        onlyTop: widget.height / 50,
                        onlyBottom: widget.height / 50,
                        child: TextWidget(
                          text: 'My Templates (${personalTemplates.length})',
                          weight: FontWeight.bold,
                          fontSize: widget.width / 22,
                        ),
                      ),
                      const Spacer(),
                      PaddingWidget(
                        type: 'only',
                        onlyRight: widget.width / 50,
                        child: ButtonWidget(
                            onPressed: widget.onPressedTemplateEditing,
                            primaryColor: Colors.green,
                            text: TextWidget(
                              text: 'Add Template',
                              weight: FontWeight.bold,
                              fontSize: widget.width / 25,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: widget.height / 5,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                            title: TextWidget(
                              text: personalTemplates[index].name,
                              weight: FontWeight.bold,
                              fontSize: widget.width / 22,
                              align: TextAlign.center,
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                PaddingWidget(
                                  onlyBottom: widget.height / 30,
                                  type: 'only',
                                  child: Align(
                                    child: TextWidget(
                                      align: TextAlign.center,
                                      text: personalTemplates[index].notes,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: widget.height / 5,
                                  width: widget.width,
                                  child: ListView.builder(
                                    semanticChildCount: personalTemplates[index].exercises.length,
                                    padding: EdgeInsets.zero,
                                    itemCount: personalTemplates[index].exercises.length,
                                    itemBuilder: (BuildContext context, int index2) {
                                      return TextWidget(
                                        text:
                                            '${personalTemplates[index].exercises[index2].sets.length} x ${personalTemplates[index].exercises[index2].assignedExercise.name}',
                                        fontSize: widget.width / 27.5,
                                        align: TextAlign.start,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              ButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      currentWorkout.exercises.clear();
                                      final List<ExerciseSet> deepCopySets = <ExerciseSet>[];
                                      for (final ExerciseSet element in personalTemplates[index].exercises) {
                                        late final ExerciseSet deepCopy;
                                        if (element.type == 'ExerciseSetWeight') {
                                          deepCopy = ExerciseSetWeight(element.assignedExercise);
                                          deepCopy.type = 'ExerciseSetWeight';
                                        } else if (element.type == 'ExerciseSetMinusWeight') {
                                          deepCopy = ExerciseSetMinusWeight(element.assignedExercise);
                                          deepCopy.type = 'ExerciseSetMinusWeight';
                                        } else {
                                          deepCopy = ExerciseSetDuration(element.assignedExercise);
                                          deepCopy.type = 'ExerciseSetDuration';
                                        }
                                        deepCopy.sets.addAll(element.sets.toList());
                                        deepCopySets.add(deepCopy);
                                      }
                                      currentWorkout.exercises.addAll(deepCopySets);
                                      currentWorkout.workoutName =
                                          TextEditingController(text: personalTemplates[index].name);
                                      currentWorkout.workoutNotes =
                                          TextEditingController(text: personalTemplates[index].notes);
                                      currentWorkout.startTime = DateTime.now();
                                    });
                                    widget.refreshPage!();
                                    Navigator.pop(context);
                                  },
                                  text: const TextWidget(text: 'Start workout with this template')),
                            ],
                          )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.width / 33.33),
                    child: Card(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                      child: PaddingWidget(
                        type: 'only',
                        onlyLeft: widget.width / 25,
                        onlyTop: widget.height / 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextWidget(
                                    text: personalTemplates[index].name,
                                    weight: FontWeight.bold,
                                    align: TextAlign.left,
                                  ),
                                ),
                                PopupMenuButton<int>(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuItem<int>>[
                                      PopupMenuItem<int>(
                                        padding: EdgeInsets.zero,
                                        value: 2,
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onPressedEditTemplate!(personalTemplates[index].id);
                                            },
                                            child: TextWidget(
                                              text: 'Edit',
                                              fontSize: widget.width / 27,
                                              color: Colors.blueAccent,
                                              weight: FontWeight.bold,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        padding: EdgeInsets.zero,
                                        value: 1,
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onPressedDeleteTemplate!(personalTemplates[index].id);
                                            },
                                            child: TextWidget(
                                              text: 'Delete',
                                              fontSize: widget.width / 27,
                                              color: Colors.red,
                                              weight: FontWeight.bold,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(FontAwesomeIcons.ellipsis),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                  iconSize: widget.height / 50,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: widget.height / 10,
                              width: widget.width / 2.75,
                              child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: personalTemplates[index].exercises.length,
                                itemBuilder: (BuildContext context, int index2) {
                                  return TextWidget(
                                    text:
                                        '${personalTemplates[index].exercises[index2].sets.length} x ${personalTemplates[index].exercises[index2].assignedExercise.name}',
                                    fontSize: widget.width / 35,
                                    align: TextAlign.start,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: personalTemplates.length,
            ),
          ),
          SliverToBoxAdapter(
              child: PaddingWidget(
            type: 'symmetric',
            vertical: widget.height / 50,
            horizontal: widget.width / 30,
            child: Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      PaddingWidget(
                        type: 'only',
                        onlyLeft: 17,
                        onlyTop: widget.height / 50,
                        onlyBottom: widget.height / 50,
                        child: TextWidget(
                          text: 'Example Templates (${systemTemplates.length})',
                          weight: FontWeight.bold,
                          fontSize: widget.width / 23,
                        ),
                      ),
                      const Spacer(),
                      PaddingWidget(
                        type: 'only',
                        onlyRight: widget.width / 50,
                        child: ButtonWidget(
                            onPressed: () {
                              setState(() {
                                hideSystemTemplates = !hideSystemTemplates;
                              });
                            },
                            primaryColor: Colors.blueGrey,
                            text: TextWidget(
                              text: hideSystemTemplates ? 'Show' : 'Hide',
                              weight: FontWeight.bold,
                              fontSize: widget.width / 25,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
          if (!hideSystemTemplates)
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: widget.height / 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              scrollable: true,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                              title: TextWidget(
                                text: systemTemplates[index].name.replaceAll(' system', ''),
                                weight: FontWeight.bold,
                                fontSize: widget.width / 22,
                                align: TextAlign.center,
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  PaddingWidget(
                                    onlyBottom: widget.height / 30,
                                    type: 'only',
                                    child: Align(
                                      child: TextWidget(
                                        text: systemTemplates[index].notes,
                                        align: TextAlign.center,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: widget.height / 5,
                                    width: widget.width,
                                    child: ListView.builder(
                                      semanticChildCount: systemTemplates[index].exercises.length,
                                      padding: EdgeInsets.zero,
                                      itemCount: systemTemplates[index].exercises.length,
                                      itemBuilder: (BuildContext context, int index2) {
                                        return TextWidget(
                                          text:
                                              '${systemTemplates[index].exercises[index2].sets.length} x ${systemTemplates[index].exercises[index2].assignedExercise.name}',
                                          fontSize: widget.width / 27.5,
                                          align: TextAlign.start,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: <Widget>[
                                ButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        currentWorkout.exercises.clear();
                                        for (final ExerciseSet element in systemTemplates[index].exercises) {
                                          late final ExerciseSet aux;
                                          if (element.type == 'ExerciseSetWeight') {
                                            aux = ExerciseSetWeight(element.assignedExercise);
                                            aux.type = element.type.toString();
                                          } else if (element.type == 'ExerciseSetMinusWeight') {
                                            aux = ExerciseSetMinusWeight(element.assignedExercise);
                                            aux.type = element.type.toString();
                                          } else {
                                            aux = ExerciseSetDuration(element.assignedExercise);
                                            aux.type = element.type.toString();
                                          }
                                          aux.sets.addAll(element.sets.toList());
                                          currentWorkout.exercises.add(aux);
                                        }
                                        currentWorkout.workoutName = TextEditingController(
                                            text: systemTemplates[index].name.replaceAll(' system', ''));
                                        currentWorkout.workoutNotes = TextEditingController(
                                            text: systemTemplates[index].notes.replaceAll(' system', ''));
                                        currentWorkout.startTime = DateTime.now();
                                      });
                                      widget.refreshPage!();
                                      Navigator.pop(context);
                                    },
                                    text: const TextWidget(text: 'Start workout with this template')),
                              ],
                            )),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.width / 33.33),
                      child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                        child: PaddingWidget(
                          type: 'only',
                          onlyLeft: widget.width / 25,
                          onlyTop: widget.height / 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PaddingWidget(
                                type: 'only',
                                onlyBottom: widget.height / 65,
                                onlyTop: widget.height / 50,
                                child: TextWidget(
                                  text: systemTemplates[index].name.replaceAll(' system', ''),
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: widget.height / 10,
                                width: widget.width / 2.75,
                                child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: systemTemplates[index].exercises.length,
                                  itemBuilder: (BuildContext context, int index2) {
                                    return TextWidget(
                                      text:
                                          '${systemTemplates[index].exercises[index2].sets.length} x ${systemTemplates[index].exercises[index2].assignedExercise.name}',
                                      fontSize: widget.width / 35,
                                      align: TextAlign.start,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: systemTemplates.length,
              ),
            ),
        ],
      ),
    );
  }
}
