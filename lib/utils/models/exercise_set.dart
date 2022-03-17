import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../ui/reusable_widgets/padding.dart';
import '../../ui/reusable_widgets/text.dart';
import 'exercise.dart';

abstract class ExerciseSet {
  ExerciseSet(this.assignedExercise);

  String? type;
  final Exercise assignedExercise;
  final List<List<TextEditingController>> sets = <List<TextEditingController>>[];

  Widget getColumnHeaderRow(double screenWidth);

  Widget getSetRow(
      int number,
      double screenWidth,
      TextEditingController? controllerReps,
      TextEditingController? controllerKg,
      TextEditingController? controllerDuration,
      TextEditingController? controllerChecked,
      Function setStateCallBack);

  void addEmptySet();
}

class ExerciseSetWeight extends ExerciseSet {
  ExerciseSetWeight(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return PaddingWidget(
      type: 'symmetric',
      horizontal: screenWidth / 50,
      child: Row(
        children: <Widget>[
          const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
          PaddingWidget(
            type: 'symmetric',
            horizontal: screenWidth / 6,
            child: const TextWidget(text: 'KG', weight: FontWeight.bold),
          ),
          PaddingWidget(
            type: 'only',
            onlyLeft: screenWidth / 11,
            onlyRight: screenWidth / 6.25,
            child: const TextWidget(text: 'Reps', weight: FontWeight.bold),
          ),
          Icon(FontAwesomeIcons.check, size: screenWidth / 30),
        ],
      ),
    );
  }

  @override
  Widget getSetRow(
      int number,
      double screenWidth,
      TextEditingController? controllerReps,
      TextEditingController? controllerKg,
      TextEditingController? controllerDuration,
      TextEditingController? controllerChecked,
      Function setStateCallBack) {
    return PaddingWidget(
      type: 'only',
      onlyLeft: screenWidth / 50,
      child: Row(
        children: <Widget>[
          PaddingWidget(
              type: 'only',
              onlyLeft: screenWidth / 25,
              child: TextWidget(
                text: '$number.',
                weight: FontWeight.bold,
                fontSize: screenWidth / 20,
              )),
          PaddingWidget(
            type: 'symmetric',
            horizontal: screenWidth / 7,
            child: SizedBox(
              width: screenWidth / 6,
              height: screenWidth / 12,
              child: Focus(
                onFocusChange: (bool focus) {
                  if (!focus) {
                    if (double.tryParse(controllerKg!.text) == null) {
                      controllerKg.text = '0';
                    }
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(top: screenWidth / 100),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: controllerKg,
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          PaddingWidget(
            type: 'only',
            onlyRight: screenWidth / 13.75,
            onlyLeft: screenWidth / 40,
            child: SizedBox(
              width: screenWidth / 6,
              height: screenWidth / 12,
              child: Focus(
                onFocusChange: (bool focus) {
                  if (!focus) {
                    // In case someone uses a ',' instead of '.'
                    if (controllerKg!.text.contains(',')) {
                      controllerKg.text.replaceAll(',', '.');
                    }
                    if (double.tryParse(controllerKg.text) == null) {
                      controllerKg.text = '0';
                    }
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(top: screenWidth / 100),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: controllerReps,
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (controllerChecked!.text == 'checked') {
                  controllerChecked.text = 'not_checked';
                } else if (controllerReps!.text != '0') {
                  controllerChecked.text = 'checked';
                }
                // ignore: avoid_dynamic_calls
                setStateCallBack();
              },
              splashRadius: 15,
              padding: EdgeInsets.zero,
              icon: Icon(
                FontAwesomeIcons.checkCircle,
                size: screenWidth / 15,
                color: controllerChecked!.text == 'checked' ? Colors.white : null,
              )),
        ],
      ),
    );
  }

  @override
  void addEmptySet() {
    final TextEditingController controllerReps = TextEditingController();
    final TextEditingController controllerKg = TextEditingController();
    final TextEditingController controllerCheck = TextEditingController();
    controllerReps.text = '0';
    controllerKg.text = '0';
    controllerCheck.text = 'not_checked';
    sets.add(<TextEditingController>[controllerReps, controllerKg, controllerCheck]);
  }
}

class ExerciseSetDuration extends ExerciseSet {
  ExerciseSetDuration(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return Row(
      children: <Widget>[
        PaddingWidget(
          type:'only',
          onlyLeft: screenWidth/40,
          child: const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
        ),
        PaddingWidget(
          type: 'only',
          onlyLeft: screenWidth / 3.4,
          onlyRight: screenWidth / 3.85,
          child: const TextWidget(text: 'Duration', weight: FontWeight.bold),
        ),
        Icon(FontAwesomeIcons.check, size: screenWidth / 30),
      ],
    );
  }

  @override
  Widget getSetRow(
      int number,
      double screenWidth,
      TextEditingController? controllerReps,
      TextEditingController? controllerKg,
      TextEditingController? controllerDuration,
      TextEditingController? controllerChecked,
      Function setStateCallBack) {
    return PaddingWidget(
      type: 'only',
      onlyLeft: screenWidth / 50,
      child: Row(
        children: <Widget>[
          PaddingWidget(
              type: 'only',
              onlyLeft: screenWidth / 25,
              child: TextWidget(
                text: '$number.',
                weight: FontWeight.bold,
                fontSize: screenWidth / 20,
              )),
          PaddingWidget(
            type: 'only',
            onlyRight: screenWidth / 7.5,
            onlyLeft: screenWidth / 4,
            child: SizedBox(
              width: screenWidth / 3,
              height: screenWidth / 12,
              child: Focus(
                onFocusChange: (bool focus) {
                  if (!focus) {
                    controllerDuration!.text = controllerDuration.text.replaceAll(':', '');
                    final int? parsedContent = int.tryParse(controllerDuration.text);
                    if (parsedContent == null) {
                      controllerDuration.text = '00:00';
                    } else {
                      if (parsedContent >= 100) {
                        int seconds = parsedContent % 100;
                        if (seconds >= 60) {
                          seconds = parsedContent % 60;
                          final int minutes = parsedContent ~/ 60;
                          if (seconds >= 10)
                            controllerDuration.text = '$minutes:$seconds';
                          else
                            controllerDuration.text = '$minutes:0$seconds';
                        } else {
                          final int minutes = parsedContent ~/ 100;
                          if (seconds >= 10)
                            controllerDuration.text = '$minutes:$seconds';
                          else
                            controllerDuration.text = '$minutes:0$seconds';
                        }
                      } else if (parsedContent < 100  && parsedContent >= 60) {
                        final int seconds = parsedContent % 60;
                        if (seconds >= 10)
                          controllerDuration.text = '01:$seconds';
                        else
                          controllerDuration.text = '01:0$seconds';
                      } else {
                        final int seconds = parsedContent % 100;
                        if (seconds >= 10)
                          controllerDuration.text = '00:$seconds';
                        else
                          controllerDuration.text = '00:0$seconds';
                      }
                    }
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(top: screenWidth / 100),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: controllerDuration,
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (controllerChecked!.text == 'checked') {
                  controllerChecked.text = 'not_checked';
                } else if (controllerReps!.text != '00:00') {
                  controllerChecked.text = 'checked';
                }
                // ignore: avoid_dynamic_calls
                setStateCallBack();
              },
              splashRadius: 15,
              padding: EdgeInsets.zero,
              icon: Icon(
                FontAwesomeIcons.checkCircle,
                size: screenWidth / 15,
                color: controllerChecked!.text == 'checked' ? Colors.white : null,
              )),
        ],
      ),
    );
  }

  @override
  void addEmptySet() {
    final TextEditingController controllerDuration = TextEditingController();
    final TextEditingController emptyController = TextEditingController();
    final TextEditingController controllerCheck = TextEditingController();
    controllerDuration.text = '00:00';
    controllerCheck.text = 'not_checked';
    sets.add(<TextEditingController>[controllerDuration, emptyController, controllerCheck]);}
}

class ExerciseSetMinusWeight extends ExerciseSet {
  ExerciseSetMinusWeight(Exercise assignedExercise) : super(assignedExercise);

  @override
  Widget getColumnHeaderRow(double screenWidth) {
    return PaddingWidget(
      type: 'symmetric',
      horizontal: screenWidth / 50,
      child: Row(
        children: <Widget>[
          const TextWidget(text: 'Set Nr.', weight: FontWeight.bold),
          PaddingWidget(
            type: 'symmetric',
            horizontal: screenWidth / 6,
            child: const TextWidget(text: '-KG', weight: FontWeight.bold),
          ),
          PaddingWidget(
            type: 'only',
            onlyLeft: screenWidth / 11,
            onlyRight: screenWidth / 7,
            child: const TextWidget(text: 'Reps', weight: FontWeight.bold),
          ),
          Icon(FontAwesomeIcons.check, size: screenWidth / 30),
        ],
      ),
    );
  }

  @override
  Widget getSetRow(
      int number,
      double screenWidth,
      TextEditingController? controllerReps,
      TextEditingController? controllerKg,
      TextEditingController? controllerDuration,
      TextEditingController? controllerChecked,
      Function setStateCallBack) {
    return PaddingWidget(
      type: 'only',
      onlyLeft: screenWidth / 50,
      child: Row(
        children: <Widget>[
          PaddingWidget(
              type: 'only',
              onlyLeft: screenWidth / 25,
              onlyRight: screenWidth / 60,
              child: TextWidget(
                text: '$number.',
                weight: FontWeight.bold,
                fontSize: screenWidth / 20,
              )),
          PaddingWidget(
            type: 'symmetric',
            horizontal: screenWidth / 7,
            child: SizedBox(
              width: screenWidth / 6,
              height: screenWidth / 12,
              child: Focus(
                onFocusChange: (bool focus) {
                  if (!focus) {
                    if (double.tryParse(controllerKg!.text) == null) {
                      controllerKg.text = '0';
                    } else if (double.parse(controllerKg.text) > 0) {
                      controllerKg.text = '-${controllerKg.text}';
                    }
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(top: screenWidth / 100),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: controllerKg,
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          PaddingWidget(
            type: 'only',
            onlyRight: screenWidth / 18.5,
            onlyLeft: screenWidth / 40,
            child: SizedBox(
              width: screenWidth / 6,
              height: screenWidth / 12,
              child: Focus(
                onFocusChange: (bool focus) {
                  if (!focus) {
                    // In case someone uses a ',' instead of '.'
                    if (controllerKg!.text.contains(',')) {
                      controllerKg.text.replaceAll(',', '.');
                    }
                    if (double.tryParse(controllerKg.text) == null) {
                      controllerKg.text = '0';
                    }
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(top: screenWidth / 100),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: controllerReps,
                  style: TextStyle(
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (controllerChecked!.text == 'checked') {
                  controllerChecked.text = 'not_checked';
                } else if (controllerReps!.text != '0') {
                  controllerChecked.text = 'checked';
                }
                // ignore: avoid_dynamic_calls
                setStateCallBack();
              },
              splashRadius: 15,
              padding: EdgeInsets.zero,
              icon: Icon(
                FontAwesomeIcons.checkCircle,
                size: screenWidth / 15,
                color: controllerChecked!.text == 'checked' ? Colors.white : null,
              )),
        ],
      ),
    );
  }

  @override
  void addEmptySet() {
    final TextEditingController controllerReps = TextEditingController();
    final TextEditingController controllerKg = TextEditingController();
    final TextEditingController controllerCheck = TextEditingController();
    controllerReps.text = '0';
    controllerKg.text = '0';
    controllerCheck.text = 'not_checked';
    sets.add(<TextEditingController>[controllerReps, controllerKg, controllerCheck]);
  }
}
