import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'padding.dart';
import 'text.dart';

class ExerciseFull extends StatelessWidget {
  const ExerciseFull(
      {Key? key, required this.image, required this.name, required this.bodyPart, this.category, this.description})
      : super(key: key);
  final String image;
  final String name;
  final String bodyPart;
  final String? category;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(text: name, weight: FontWeight.bold, fontSize: 23),
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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