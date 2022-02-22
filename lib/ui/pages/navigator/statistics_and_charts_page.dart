import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/models/user_database.dart';

class StatisticsAndChartsPage extends StatefulWidget {
  const StatisticsAndChartsPage({Key? key, required this.user}) : super(key: key);
  final UserDB user;

  @override
  State<StatisticsAndChartsPage> createState() => _StatisticsAndChartsPageState();
}

class _StatisticsAndChartsPageState extends State<StatisticsAndChartsPage> {
  bool logoutPressed = false;

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Your personal statistics and charts page'),
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
