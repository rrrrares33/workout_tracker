import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
import 'welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WorkoutTracker());
}
