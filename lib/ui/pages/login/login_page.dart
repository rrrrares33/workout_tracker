import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import '../../../routing/routing_constants.dart';
import '../../text/login_text.dart';

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

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text(alreadyAccountLogIn),
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
              label: const Text(logInButtonLabel),
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
            ),
          ),
          const Text(logInWithOtherServices),
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
                    ScaffoldMessenger.of(context).showSnackBar(loggedSuccessful);
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
                label: const Text(logInWithGoogle),
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
                label: const Text(logInWithFacebook),
              )),
          const Text(createANewAccountQuestion),
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
                  label: const Text(createANewAccount)),
            ),
          ),
        ],
      ),
    );
  }
}
