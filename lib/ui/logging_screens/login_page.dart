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
                  await authenticationService.signInWithGoogle();
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
                  await authenticationService.signInWithFacebook();
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
