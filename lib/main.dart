import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'ui/landing_intermediary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WorkoutTracker());
}
