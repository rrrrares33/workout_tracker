import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/firebase/database_service.dart';
import '../../utils/firebase/firebase_service.dart';
import '../../utils/models/exercise.dart';
import '../text/all_exercises_text.dart';
import 'button.dart';
import 'dropdown_button.dart';
import 'padding.dart';
import 'text.dart';
import 'text_field.dart';

class AddANewExerciseWidget extends StatefulWidget {
  const AddANewExerciseWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.formKey,
    required this.newTitleController,
    required this.newDescriptionController,
    required this.databaseService,
    required this.userUid,
    required this.localExerciseList,
  }) : super(key: key);

  final double width;
  final double height;
  final Key formKey;
  final String userUid;
  final List<Exercise> localExerciseList;

  final TextEditingController newTitleController;

  final TextEditingController newDescriptionController;

  final DatabaseService databaseService;

  @override
  State<AddANewExerciseWidget> createState() => _AddANewExerciseWidgetState();
}

class _AddANewExerciseWidgetState extends State<AddANewExerciseWidget> {
  String newChosenValueBodyPart = defaultBodyPart;
  String newChosenValueCategory = defaultCategory;
  bool errorTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
        tooltip: addNewExerciseText,
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: () => showDialog<Widget>(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) => AlertDialog(
                    scrollable: true,
                    alignment: Alignment.topCenter,
                    insetPadding: EdgeInsets.symmetric(horizontal: widget.width / 10, vertical: widget.width / 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: TextWidget(
                      text: 'Create A New Exercise',
                      weight: FontWeight.bold,
                      fontSize: widget.width / 25,
                    ),
                    content: Form(
                        key: widget.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFieldWidget(
                                labelText: 'Exercise name',
                                hintText: 'Exercise name...',
                                controller: widget.newTitleController,
                                borderType: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                fontSize: widget.width / 30,
                                onChanged: (_) {
                                  setState(() {
                                    errorTextVisible = false;
                                  });
                                },
                                suffixIcon: GestureDetector(
                                  child: const Icon(FontAwesomeIcons.solidTimesCircle, color: Colors.grey),
                                  onTap: () {
                                    setState(() {
                                      widget.newTitleController.clear();
                                    });
                                  },
                                )),
                            const PaddingWidget(
                              type: 'symmetric',
                              vertical: 5,
                            ),
                            TextFieldWidget(
                              keyboardType: TextInputType.multiline,
                              labelText: 'Exercise description',
                              hintText: 'Exercise description (optional)...',
                              controller: widget.newDescriptionController,
                              borderType: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              fontSize: widget.width / 30,
                              maxLines: 5,
                              onChanged: (_) {},
                              suffixIcon: GestureDetector(
                                child: const Icon(FontAwesomeIcons.solidTimesCircle, color: Colors.grey),
                                onTap: () {
                                  setState(() {
                                    widget.newDescriptionController.clear();
                                  });
                                },
                              ),
                            ),
                            const PaddingWidget(
                              type: 'symmetric',
                              vertical: 5,
                            ),
                            DropDownButtonWidget(
                              defaultValue: defaultBodyPart,
                              currentValue: newChosenValueBodyPart,
                              width: widget.width / 2,
                              height: widget.height / 27.5,
                              iconSize: 24.0,
                              align: Alignment.centerLeft,
                              items: bodyPart,
                              onChanged: (String? value) {
                                setState(() {
                                  errorTextVisible = false;
                                  newChosenValueBodyPart = value!;
                                });
                              },
                            ),
                            const PaddingWidget(
                              type: 'symmetric',
                              vertical: 5,
                            ),
                            DropDownButtonWidget(
                              defaultValue: defaultCategory,
                              currentValue: newChosenValueCategory,
                              width: widget.width / 2,
                              height: widget.height / 27.5,
                              iconSize: 24.0,
                              align: Alignment.centerLeft,
                              items: category,
                              onChanged: (String? value) {
                                setState(() {
                                  errorTextVisible = false;
                                  newChosenValueCategory = value!;
                                });
                              },
                            ),
                            Visibility(
                              visible: errorTextVisible,
                              child: const PaddingWidget(
                                type: 'only',
                                onlyTop: 10,
                                child: TextWidget(
                                  text: 'You can not add an exercise without name, body part or category',
                                  fontStyle: FontStyle.italic,
                                  color: Colors.redAccent,
                                ),
                              ),
                            )
                          ],
                        )),
                    actions: <Widget>[
                      ButtonWidget(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: const TextWidget(text: 'Close'),
                          primaryColor: Colors.redAccent,
                          minimumSize: Size.fromRadius(widget.width / 20)),
                      const PaddingWidget(type: 'symmetric', horizontal: 2.5),
                      ButtonWidget(
                          onPressed: () async {
                            if (widget.newTitleController.text == '' ||
                                newChosenValueCategory == defaultCategory ||
                                newChosenValueBodyPart == defaultBodyPart) {
                              setState(() {
                                errorTextVisible = true;
                              });
                            } else {
                              widget.databaseService.createNewExercise(
                                  widget.userUid,
                                  widget.newTitleController.text,
                                  widget.newDescriptionController.text,
                                  newChosenValueCategory,
                                  newChosenValueBodyPart,
                                  FirebaseService());
                              final Exercise aux = Exercise(
                                  widget.newTitleController.text,
                                  widget.newDescriptionController.text,
                                  '${widget.userUid}_${widget.newTitleController.text}',
                                  widget.userUid,
                                  newChosenValueCategory,
                                  newChosenValueBodyPart,
                                  '',
                                  '');
                              setState(() {
                                widget.localExerciseList.add(aux);
                              });
                              Navigator.pop(context);
                            }
                          },
                          text: const TextWidget(text: 'Create'),
                          minimumSize: Size.fromRadius(widget.width / 20)),
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  ),
                )));
  }
}
