import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/database_service.dart';
import '../../models/user_database.dart';

class CheckFirstTime extends StatelessWidget {
  const CheckFirstTime({Key? key, required this.loggedUserUid, required this.loggedEmail}) : super(key: key);
  final String loggedUserUid;
  final String loggedEmail;
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return FutureBuilder<bool>(
      future: databaseService.initializeEntities(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshotFuture) {
        if (!snapshotFuture.hasData) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          UserDB? loggedUser = databaseService.getUserBaseOnUid(loggedUserUid);
          if (loggedUser == null) {
            databaseService.createUserBeforeDetails(loggedUserUid, loggedEmail);
            loggedUser = UserDB(loggedUserUid, loggedEmail, true);
          }
          if (loggedUser.firstEntry == true) {
            return const Scaffold(
                body: Center(
              child: Text('User is at first entry'),
            ));
          } else {
            return const Scaffold(
                body: Center(
              child: Text('User is not at first entry'),
            ));
          }
        }
      },
    );
  }
}
