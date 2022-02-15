import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import '../../../models/user_database.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key, required this.user}) : super(key: key);
  final UserDB user;

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool logoutPressed = false;
  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return WillPopScope(
      onWillPop: () async => logoutPressed,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('App'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have successfully logged in.'),
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
          )),
    );
  }
}
