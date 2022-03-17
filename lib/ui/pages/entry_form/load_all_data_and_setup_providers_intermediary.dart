import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/database_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/routing/current_opened_page.dart';
import '../../reusable_widgets/loading.dart';
import '../navigator/main_screen_page.dart';

class LoadAllExercisesIntermediary extends StatelessWidget {
  const LoadAllExercisesIntermediary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final UserDB user = Provider.of<UserDB>(context);
    return FutureBuilder<List<Exercise>>(
        future: databaseService.getAllExercisesForUser(user.uid, context),
        builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshotFuture) {
          if (!snapshotFuture.hasData) {
            return const LoadingWidget();
          } else {
            return MultiProvider(
              providers: <Provider<dynamic>>[
                Provider<List<Exercise>>(
                  create: (_) => snapshotFuture.data!,
                ),
                Provider<CurrentWorkout>(
                  create: (_) => CurrentWorkout(),
                ),
                Provider<CurrentOpenedPage>(
                  create: (_) => CurrentOpenedPage(),
                ),
              ],
              child: const MainScreenPage(),
            );
          }
        });
  }
}