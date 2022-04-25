import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/models/current_workout.dart';
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
    this.refreshPage,
  }) : super(key: key);
  final ScrollController scrollController;
  final double toolbarHeight;
  final double expandedHeight;
  final bool showBigLeftTitle;
  final double width;
  final double height;
  final List<WorkoutTemplate> templates;
  final void Function()? refreshPage;
  final void Function()? onPressedStartEmpty;
  final void Function()? onPressedTemplateEditing;

  @override
  State<WorkoutPageIdle> createState() => _WorkoutPageIdleState();
}

class _WorkoutPageIdleState extends State<WorkoutPageIdle> {
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
              type: 'symmetric',
              vertical: widget.height / 50,
              horizontal: widget.width / 30,
              child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                color: Colors.black12,
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
              color: Colors.black12,
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
                          text: 'My Templates',
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
                              text: 'New Template',
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
              mainAxisExtent: widget.height / 5.7,
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
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                PaddingWidget(
                                  onlyBottom: widget.height / 30,
                                  type: 'only',
                                  child: TextWidget(
                                    text: personalTemplates[index].notes,
                                    align: TextAlign.start,
                                    fontStyle: FontStyle.italic,
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
                                      currentWorkout.exercises.addAll(personalTemplates[index].exercises);
                                      currentWorkout.workoutName =
                                          TextEditingController(text: personalTemplates[index].name);
                                      currentWorkout.startTime = DateTime.now();
                                    });
                                    widget.refreshPage!();
                                    Navigator.pop(context);
                                  },
                                  text: const TextWidget(text: 'Start workout with these template')),
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
                            TextWidget(
                              text: personalTemplates[index].name,
                              weight: FontWeight.bold,
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
              color: Colors.black12,
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
                          text: 'System Templates',
                          weight: FontWeight.bold,
                          fontSize: widget.width / 23,
                        ),
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
              mainAxisExtent: widget.height / 5.7,
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
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                PaddingWidget(
                                  onlyBottom: widget.height / 30,
                                  type: 'only',
                                  child: TextWidget(
                                    text: systemTemplates[index].notes,
                                    align: TextAlign.start,
                                    fontStyle: FontStyle.italic,
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
                                      currentWorkout.exercises.addAll(systemTemplates[index].exercises);
                                      currentWorkout.workoutName = TextEditingController(
                                          text: systemTemplates[index].name.replaceAll(' system', ''));
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
