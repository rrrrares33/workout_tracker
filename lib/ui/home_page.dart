import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/authentication_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have successfully logged in.'),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authenticationService.signOutFromFirebase();
                },
                child: const Text('Logout'),
              ),
            )
          ],
        ));
  }
}
