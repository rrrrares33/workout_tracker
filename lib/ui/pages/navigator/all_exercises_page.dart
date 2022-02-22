import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/models/user_database.dart';

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
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('All exercises page'),
        Text(widget.user.name!),
        Text(widget.user.surname!),
        Text(widget.user.email),
        Text(widget.user.uid),
        Text(widget.user.age.toString()),
        Text(widget.user.weight.toString()),
        Text(widget.user.weightType.toString()),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                logoutPressed = true;
              });
              await authenticationService.signOutFromFirebase();
            },
            child: const Text('Logout'),
          ),
        )
      ],
    );
  }
}
