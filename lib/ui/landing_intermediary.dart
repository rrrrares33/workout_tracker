import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        child: AdaptiveTheme(
          light: ThemeClass.lightTheme,
          dark: ThemeClass.darkTheme,
          initial: SchedulerBinding.instance!.window.platformBrightness == Brightness.dark
              ? AdaptiveThemeMode.dark
              : AdaptiveThemeMode.light,
          builder: (ThemeData theme, ThemeData darkTheme) => MaterialApp(
            title: 'Workout History',
            theme: theme,
            onGenerateRoute: RoutersLanding.generateRoute,
            debugShowCheckedModeBanner: false,
            initialRoute: LandingPageRoute,
          ),
        ));
  }
}
