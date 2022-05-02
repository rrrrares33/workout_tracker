import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      this.onPressedSaveEditing})
      : super(key: key);
  final String image;
  final String name;
  final String bodyPart;
  final String id;
  final String? category;
  final String? description;
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
            Center(
              child: CachedNetworkImage(
                imageUrl: image,
                progressIndicatorBuilder: (BuildContext context, String image, DownloadProgress downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (BuildContext context, String image, dynamic error) => const Icon(Icons.error),
              ),
            ),
          const PaddingWidget(type: 'symmetric', vertical: 10),
          const TextWidget(text: 'Description', weight: FontWeight.bold),
          PaddingWidget(
            type: 'only',
            onlyLeft: 10,
            child: TextWidget(text: description, fontStyle: FontStyle.italic),
          ),
          const PaddingWidget(type: 'symmetric', vertical: 10),
          TextWidget(text: 'Category --  $category', weight: FontWeight.w600),
          const PaddingWidget(type: 'symmetric', vertical: 10),
          TextWidget(text: 'Main Body Part Worked -- $bodyPart', weight: FontWeight.w600),
        ],
      ),
    );
  }
}
