import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/user_database.dart';
import '../../widgets/loading.dart';
import 'load_history_and_setup_providers.dart';

class LoadAllExercisesIntermediary extends StatelessWidget {
  const LoadAllExercisesIntermediary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final UserDB user = Provider.of<UserDB>(context);
    return FutureBuilder<List<Exercise>>(
        future: databaseService.getAllExercisesForUser(user.uid, context, FirebaseService()),
        builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshotFuture) {
          if (!snapshotFuture.hasData) {
            return const LoadingWidget(text: 'Loading all exercises...');
          } else {
            return MultiProvider(
              providers: <Provider<dynamic>>[
                Provider<List<Exercise>>(
                  create: (_) => snapshotFuture.data!,
                ),
              ],
              child: const LoadHistoryAndSetupProviders(),
            );
          }
        });
  }
}
