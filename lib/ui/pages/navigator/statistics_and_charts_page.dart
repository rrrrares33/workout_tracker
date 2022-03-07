import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/models/user_database.dart';

class StatisticsAndChartsPage extends StatefulWidget {
  const StatisticsAndChartsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsAndChartsPage> createState() => _StatisticsAndChartsPageState();
}

class _StatisticsAndChartsPageState extends State<StatisticsAndChartsPage> {
  bool logoutPressed = false;

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    final UserDB user = Provider.of<UserDB>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Your personal statistics and charts page'),
        Text(user.name!),
        Text(user.surname!),
        Text(user.email),
        Text(user.uid),
        Text(user.age.toString()),
        Text(user.weight.toString()),
        Text(user.weightType.toString()),
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
