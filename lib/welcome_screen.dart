import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routing/all_routes.dart';
import '../routing/routing_constants.dart';
import 'firebase/authentication_service.dart';

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
          title: 'Flutter App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: Routers.generateRoute,
          initialRoute: LandingPageRoute,
        ));
  }
}
