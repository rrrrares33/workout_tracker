import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/firebase/authentication_service.dart';
import '../utils/firebase/database_service.dart';
import '../utils/routing/all_routes_landing.dart';
import '../utils/routing/routing_constants.dart';
import 'theme_data.dart';

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <Provider<dynamic>>[
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(),
          ),
          Provider<DatabaseService>(
            create: (_) => DatabaseService(),
          )
        ],
        child: MaterialApp(
          title: 'Workout Supervisor',
          darkTheme: ThemeClass.darkTheme,
          theme: ThemeClass.lightTheme,
          onGenerateRoute: RoutersLanding.generateRoute,
          initialRoute: LandingPageRoute,
        ));
  }
}
