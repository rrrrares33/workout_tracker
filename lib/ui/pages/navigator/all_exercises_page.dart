import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/models/user_database.dart';
import '../../reusable_widgets/loading.dart';
import '../../reusable_widgets/padding.dart';

class AllExercisesPage extends StatefulWidget {
  const AllExercisesPage({Key? key, required this.user}) : super(key: key);
  final UserDB user;

  @override
  State<AllExercisesPage> createState() => _AllExercisesPageState();
}

class _AllExercisesPageState extends State<AllExercisesPage> {
  bool logoutPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          children: <Widget>[
            PaddingWidget(
              type: 'only',
              onlyTop: 40,
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/workouttrackerdb.appspot.com/o/chest_images%2Ffull_images%2Fbench_press_barbell.png?alt=media&token=6d45ca32-0ca7-4c7e-954b-2d43e06b6e14',
                placeholder: (BuildContext context, String url) => const LoadingWidget(),
                errorWidget: (BuildContext context, String url, dynamic error) => const Icon(Icons.error),
                width: 200.0,
                height: 200.0,
              ),
            ),
          ],
        ));
  }
}
