import 'package:flutter/material.dart';

import 'loading.dart';
import 'padding.dart';
import 'text.dart';

String removeCategoryFromName(String name) {
  const List<String> listOfCategories = <String>[
    'One Arm ',
    'One Arm',
  ];
  for (final String aux in listOfCategories) {
    name = name.replaceAll(aux, '');
  }
  name = name.replaceAll('Pushups', 'Push Up');
  name = name.replaceAll('Push Ups', 'Push Up');
  return name;
}

class ExerciseSmallShow extends StatelessWidget {
  const ExerciseSmallShow(
      {Key? key,
      required this.image,
      required this.name,
      required this.bodyPart,
      this.category,
      this.onTap,
      required this.imageWidth,
      required this.imageHeight})
      : super(key: key);
  final String image;
  final String name;
  final String bodyPart;
  final String? category;
  final void Function()? onTap;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PaddingWidget(
        type: 'symmetric',
        horizontal: 5.0,
        vertical: 2.5,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey,
          ),
          child: Row(
            children: <Widget>[
              PaddingWidget(
                  type: 'all',
                  all: 5,
                  child: Image(
                    image: AssetImage(image),
                    width: imageWidth,
                    height: imageHeight,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: LoadingWidget(),
                      );
                    },
                  )),
              const PaddingWidget(
                type: 'symmetric',
                horizontal: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    text: removeCategoryFromName(name),
                    weight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  const PaddingWidget(
                    type: 'symmetric',
                    vertical: 5,
                  ),
                  TextWidget(
                    text: category != null ? '$bodyPart    ----    ${category!}' : bodyPart,
                    weight: FontWeight.w100,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
