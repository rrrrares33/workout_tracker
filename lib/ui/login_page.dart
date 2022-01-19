import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../firebase/authentication_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // Controllers for textFields.
  // One for email and one for password.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Whether it should hide content of the TextField field.
  late bool _doNotShowPassword = true;

  // Regex expression for email.
  final RegExp _regexEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Between 8 and 20 characters, at least one uppercase letter, one lowercase letter,
  //    one number and one special character:
  final RegExp _regexPassword = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[.,@$!%*?&])[A-Za-z\d@$!.,%*?&]{8,20}$');

  String? _emailWarning;

  String? _passwordWarning;

  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      onChanged: (String text) {
                        if (text == '' || !_regexEmail.hasMatch(text)) {
                          setState(() {
                            _emailWarning = 'Email is not valid.';
                          });
                        } else {
                          setState(() {
                            _emailWarning = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Email ...',
                        errorText: _emailWarning ?? _passwordWarning,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      obscureText: _doNotShowPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Password...',
                        errorText: _passwordWarning,
                        suffixIcon: IconButton(
                          icon: Icon(_doNotShowPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                          onPressed: () {
                            setState(() {
                              _doNotShowPassword = !_doNotShowPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(45),
                primary: Colors.blueGrey,
              ),
              onPressed: () {
                setState(() {
                  if (!_regexPassword.hasMatch(passwordController.text)) {
                    _passwordWarning = 'This combination does not exist.';
                  } else {
                    _passwordWarning = null;
                  }
                });
                if (_emailWarning == null &&
                    passwordController.text != '' &&
                    _passwordWarning == null)
                  authenticationService.signInUserEmailPassword(
                      emailController.text, passwordController.text);
              },
              label: const Text('Sing In with email and password.'),
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(45),
                  primary: Colors.redAccent,
                ),
                onPressed: () {
                  authenticationService.signInWithGoogle();
                },
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Sign In with a Google account.'),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(45),
                  primary: Colors.blue,
                ),
                onPressed: () {
                  authenticationService.signInWithFacebook();
                },
                icon: const FaIcon(FontAwesomeIcons.facebook),
                label: const Text('Sign In with a Facebook account.'),
              )),
          const Text('Do you want to create a new account?'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 5,
                  textStyle: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                child: const Text('Register')),
          ),
        ],
      ),
    );
  }
}
