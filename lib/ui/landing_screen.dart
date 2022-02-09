import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routing/all_routes_landing.dart';
import '../../routing/routing_constants.dart';
import '../firebase/authentication_service.dart';
import 'login/theme_data.dart';

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <Provider<dynamic>>[
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(),
          ),
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
