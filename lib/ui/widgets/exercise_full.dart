import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../business_logic/all_exercises_logic.dart';
import '../../utils/models/history_workout.dart';
import 'button.dart';
import 'padding.dart';
import 'text.dart';

//ignore: must_be_immutable
class ExerciseFull extends StatelessWidget {
  ExerciseFull(
      {Key? key,
      required this.image,
      required this.name,
      required this.bodyPart,
      this.category,
      this.description,
      this.onPressedDeleteExercise,
      required this.id,
      this.onPressedSaveEditing,
      required this.history})
      : super(key: key);
  final String image;
  final String name;
  final String bodyPart;
  final String id;
  final String? category;
  final String? description;
  final List<HistoryWorkout> history;
  final void Function(String, String)? onPressedDeleteExercise;
  final void Function(String, String, String)? onPressedSaveEditing;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(text: name, weight: FontWeight.bold, fontSize: 23),
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        if (image == '' || image == 'userCreatedNoIcon')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonWidget(
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const TextWidget(
                          text: 'Editing',
                          weight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: titleController,
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text(name),
                              ),
                            ),
                            TextField(
                              controller: descriptionController,
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text(description ?? ''),
                              ),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: <Widget>[
                          ButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: const TextWidget(text: 'Cancel'),
                            primaryColor: Colors.red,
                          ),
                          ButtonWidget(
                            onPressed: () {
                              Navigator.pop(context);
                              if ((descriptionController.text != description &&
                                      descriptionController.text.isNotEmpty) ||
                                  (titleController.text != name && titleController.text.isNotEmpty)) {
                                final String titleToReturn = titleController.text != '' ? titleController.text : name;
                                final String? descriptionControllerToReturn =
                                    descriptionController.text != '' ? descriptionController.text : description;
                                onPressedSaveEditing!(id, titleToReturn, descriptionControllerToReturn!);
                              }
                            },
                            text: const TextWidget(text: 'Save'),
                            primaryColor: Colors.greenAccent,
                          ),
                        ],
                      );
                    }),
                text: const TextWidget(text: 'Edit'),
                primaryColor: Colors.blueAccent,
              ),
              const PaddingWidget(
                type: 'symmetric',
                horizontal: 10,
              ),
              ButtonWidget(
                onPressed: () {
                  Navigator.pop(context);
                  if (onPressedDeleteExercise != null) {
                    onPressedDeleteExercise!(name, id);
                  }
                },
                text: const TextWidget(text: 'Delete'),
                primaryColor: Colors.redAccent,
              ),
            ],
          )
        else
          const SizedBox(
            width: 0,
            height: 0,
          ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image == '' || image == 'userCreatedNoIcon')
            Container()
          else
            Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const TextWidget(text: '----How to do----', weight: FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: image,
                          progressIndicatorBuilder:
                              (BuildContext context, String image, DownloadProgress downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (BuildContext context, String image, dynamic error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const PaddingWidget(type: 'symmetric', vertical: 10),
          Center(
            child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const TextWidget(
                        text: '----Description---',
                        weight: FontWeight.bold,
                      ),
                      TextWidget(text: '$description'),
                    ],
                  ),
                )),
          ),
          const PaddingWidget(type: 'symmetric', vertical: 5),
          Center(
            child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const TextWidget(
                        text: '----Category---',
                        weight: FontWeight.bold,
                      ),
                      TextWidget(text: '$category'),
                    ],
                  ),
                )),
          ),
          const PaddingWidget(type: 'symmetric', vertical: 5),
          Center(
            child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const TextWidget(
                        text: '----Worked Body Part---',
                        weight: FontWeight.bold,
                      ),
                      TextWidget(text: bodyPart),
                    ],
                  ),
                )),
          ),
          const PaddingWidget(type: 'symmetric', vertical: 5),
          if (getRPMForExercise(history, id, category!) != '')
            Center(
              child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        const TextWidget(
                          text: '----Personal One Rep Record---',
                          weight: FontWeight.bold,
                        ),
                        TextWidget(text: getRPMForExercise(history, id, category!)),
                      ],
                    ),
                  )),
            )
          else
            Container(),
        ],
      ),
    );
  }
}
