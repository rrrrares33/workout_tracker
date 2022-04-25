import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/firebase/database_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/editing_template.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/history_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/workout_template.dart';
import '../../../utils/routing/current_opened_page.dart';
import '../../reusable_widgets/loading.dart';
import '../navigator/main_screen_page.dart';

class LoadHistoryAndSetupProviders extends StatelessWidget {
  const LoadHistoryAndSetupProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final List<Exercise> exercises = Provider.of<List<Exercise>>(context);
    final UserDB user = Provider.of<UserDB>(context);
    return FutureBuilder<List<HistoryWorkout>>(
        future: databaseService.getAllHistoryFromDBForUser(user.uid, exercises),
        builder: (BuildContext context, AsyncSnapshot<List<HistoryWorkout>> snapshotFuture) {
          if (!snapshotFuture.hasData) {
            return const LoadingWidget();
          } else {
            return MultiProvider(
                providers: <Provider<dynamic>>[
                  Provider<List<HistoryWorkout>>(
                    create: (_) => snapshotFuture.data!,
                  ),
                  Provider<CurrentWorkout>(
                    create: (_) => CurrentWorkout(),
                  ),
                  Provider<EditingTemplate>(
                    create: (_) => EditingTemplate(),
                  ),
                  Provider<CurrentOpenedPage>(
                    create: (_) => CurrentOpenedPage(),
                  ),
                ],
                child: FutureBuilder<List<WorkoutTemplate>>(
                  future: databaseService.getAllWorkoutTemplatesFromDBForUser(user.uid, exercises),
                  builder: (BuildContext contextAux, AsyncSnapshot<List<WorkoutTemplate>> snapshotFutureTemplates) {
                    if (!snapshotFutureTemplates.hasData) {
                      return const LoadingWidget();
                    } else {
                      return MultiProvider(providers: <Provider<dynamic>>[
                        Provider<List<WorkoutTemplate>>(
                          create: (_) => snapshotFutureTemplates.data!,
                        )
                      ], child: const MainScreenPage());
                    }
                  },
                )
                //const MainScreenPage(),
                );
          }
        });
  }
}
