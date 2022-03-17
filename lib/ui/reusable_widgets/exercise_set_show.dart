import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/models/exercise_set.dart';
import 'button.dart';
import 'exercise_full.dart';
import 'padding.dart';
import 'text.dart';

class ExerciseSetShow extends StatefulWidget {
  const ExerciseSetShow({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.setExercise,
    required this.onPressedAddSet,
  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final ExerciseSet setExercise;
  final Function() onPressedAddSet;

  @override
  State<ExerciseSetShow> createState() => _ExerciseSetShowState();
}

class _ExerciseSetShowState extends State<ExerciseSetShow> {
  void setStateCallBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PaddingWidget(
      type: 'symmetric',
      horizontal: widget.screenWidth / 35,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: PaddingWidget(
                type: 'only',
                onlyLeft: widget.screenWidth / 50,
                child: GestureDetector(
                  child: TextWidget(
                    align: TextAlign.start,
                    text: widget.setExercise.assignedExercise.name,
                    weight: FontWeight.bold,
                    fontSize: widget.screenWidth / 20,
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => ExerciseFull(
                      image: widget.setExercise.assignedExercise.biggerImage,
                      name: widget.setExercise.assignedExercise.name,
                      bodyPart: widget.setExercise.assignedExercise.bodyPart,
                      category: widget.setExercise.assignedExercise.category,
                      description: widget.setExercise.assignedExercise.description,
                    ),
                  ),
                ),
              )),
              IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.ellipsisH))
            ],
          ),
          widget.setExercise.getColumnHeaderRow(widget.screenWidth),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: widget.screenHeight / 100),
              primary: false,
              itemCount: widget.setExercise.sets.length,
              itemBuilder: (BuildContext context, int index) {
                return PaddingWidget(
                  type: 'only',
                  onlyTop: widget.screenHeight / 250,
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.14,
                      openThreshold: 0.05,
                      children: <Widget>[
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            setState(() {
                              widget.setExercise.sets.removeAt(index);
                            });
                          },
                          foregroundColor: Colors.redAccent,
                          icon: FontAwesomeIcons.timesCircle,
                          backgroundColor: Colors.transparent,
                          spacing: 0,
                        ),
                      ],
                    ),
                    enabled: widget.setExercise.sets[index][2].text != 'checked',
                    child: Container(
                        decoration: BoxDecoration(
                          color: widget.setExercise.sets[index][2].text == 'checked'
                              ? Colors.greenAccent[200]
                              : Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: widget.setExercise.getSetRow(
                            index + 1,
                            widget.screenWidth,
                            widget.setExercise.sets[index][0],
                            widget.setExercise.sets[index][1],
                            widget.setExercise.sets[index][0],
                            widget.setExercise.sets[index][2],
                            setStateCallBack)),
                  ),
                );
              },
            ),
          ),
          ButtonWidget(
            onPressed: widget.onPressedAddSet,
            primaryColor: Colors.black54,
            minimumSize: Size.fromHeight(widget.screenWidth / 15),
            text: const TextWidget(text: '+ Add another set'),
          )
        ],
      ),
    );
  }
}