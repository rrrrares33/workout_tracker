import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WorkoutTracker());
}
