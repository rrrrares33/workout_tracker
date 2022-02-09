import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../firebase/authentication_service.dart';
import '../../routing/routing_constants.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    const SnackBar loggedInSuccess = SnackBar(content: Text('You have successfully logged in!'));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text('You already have an account? Log In!'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(52),
                primary: Colors.blueGrey,
              ),
              onPressed: () {
                Navigator.pushNamed(context, LogInWithEmailAndPasswordRoute);
              },
              label: const Text('Log In with email and password.'),
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
            ),
          ),
          const Text('Do you want to log in using other services?'),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(52),
                  primary: Colors.redAccent,
                ),
                onPressed: () async {
                  try {
                    await authenticationService.signInWithGoogle();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(loggedInSuccess);
                  } on FirebaseAuthException catch (e) {
                    if (e.message != null) {
                      // Development:
                      final SnackBar failedLoginSnackBar = SnackBar(content: Text('Google ${e.message ?? ''}'));
                      // Production:
                      //const SnackBar failedLoginSnackBar = SnackBar(content: Text('Log In could not be made.'));
                      ScaffoldMessenger.of(context).showSnackBar(failedLoginSnackBar);
                    }
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Sign In with a Google account.'),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(52),
                  primary: Colors.blue,
                ),
                onPressed: () async {
                  try {
                    await authenticationService.signInWithFacebook();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(loggedInSuccess);
                  } on FirebaseAuthException catch (e) {
                    if (e.message != null) {
                      // Development:
                      final SnackBar failedLoginSnackBar = SnackBar(content: Text('Facebook ${e.message ?? ''}'));
                      // Production:
                      //const SnackBar failedLoginSnackBar = SnackBar(content: Text('Log In could not be made.'));
                      ScaffoldMessenger.of(context).showSnackBar(failedLoginSnackBar);
                    }
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.facebook),
                label: const Text('Sign In with a Facebook account.'),
              )),
          const Text('Do you want to create a new account?'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: const Size.fromHeight(52),
                    textStyle: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPageRoute);
                  },
                  icon: const FaIcon(FontAwesomeIcons.solidUserCircle),
                  label: const Text('Register a new local account.')),
            ),
          ),
        ],
      ),
    );
  }
}
