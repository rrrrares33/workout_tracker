import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/login_and_register_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/weight_tracker.dart';
import '../../widgets/loading.dart';
import 'load_exercises.dart';
import 'user_details_form_page.dart';

class CheckFirstTimeAndLoadDB extends StatelessWidget {
  const CheckFirstTimeAndLoadDB({Key? key, required this.loggedUserUid, required this.loggedEmail}) : super(key: key);
  final String loggedUserUid;
  final String loggedEmail;

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return FutureBuilder<bool>(
      future: databaseService.loadUsers(FirebaseService()),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshotFuture) {
        if (!snapshotFuture.hasData) {
          return const LoadingWidget();
        } else {
          final UserDB? loggedUser =
              getUserOrCreateIfNullUsingUID(FirebaseService(), databaseService, loggedUserUid, loggedEmail);
          if (loggedUser?.firstEntry == true) {
            return UserDetailsForm(loggedUserUid: loggedUserUid, loggedEmail: loggedEmail);
          } else {
            return MultiProvider(
                providers: <Provider<dynamic>>[
                  Provider<UserDB>(
                    create: (_) => loggedUser!,
                  ),
                ],
                child: FutureBuilder<WeightTracker>(
                    future: databaseService.getWeightTrackerForUser(loggedUser!, FirebaseService()),
                    builder: (BuildContext context, AsyncSnapshot<WeightTracker> snapshotFuture) {
                      if (!snapshotFuture.hasData) {
                        return const LoadingWidget();
                      } else {
                        return MultiProvider(providers: <Provider<dynamic>>[
                          Provider<WeightTracker>(
                            create: (_) => snapshotFuture.data!,
                          ),
                        ], child: const LoadAllExercisesIntermediary());
                      }
                    }));
          }
        }
      },
    );
  }
}
