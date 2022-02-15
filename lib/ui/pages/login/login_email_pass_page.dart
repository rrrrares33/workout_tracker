import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import 'authentification_base.dart';

class LogInPageEmailAndPassword extends StatefulWidget {
  const LogInPageEmailAndPassword({Key? key}) : super(key: key);

  @override
  State<LogInPageEmailAndPassword> createState() => _LogInPageEmailAndPasswordState();
}

class _LogInPageEmailAndPasswordState extends State<LogInPageEmailAndPassword> with AuthentificationBase {
  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    const SnackBar loggedInSuccess = SnackBar(content: Text('You have successfully logged in!'));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Log into your account'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      onChanged: (String text) {
                        if (text != '' && !regexEmail.hasMatch(text)) {
                          setState(() {
                            generalError = null;
                            emailWarning = 'Email is not valid.';
                          });
                        } else {
                          setState(() {
                            emailWarning = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Email ...',
                        errorText: emailWarning,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextField(
                      obscureText: doNotShowPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Password...',
                        suffixIcon: IconButton(
                          icon: Icon(doNotShowPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                          onPressed: () {
                            setState(() {
                              doNotShowPassword = !doNotShowPassword;
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
          Text(
            generalError != null ? generalError.toString() : '',
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(52),
                primary: Colors.blueGrey,
              ),
              onPressed: () async {
                setState(() {
                  if (!regexPassword.hasMatch(passwordController.text)) {
                    generalError = 'This account does not exist.';
                  } else {
                    generalError = null;
                  }
                });
                if (emailWarning == null && passwordController.text != '' && generalError == null) {
                  try {
                    await authenticationService.signInUserEmailPassword(emailController.text, passwordController.text);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(loggedInSuccess);
                    Future<dynamic>.delayed(Duration.zero).then((_) {
                      Navigator.of(context).pop();
                    });
                  } catch (exception) {
                    setState(() {
                      generalError = 'This account does not exist.';
                    });
                  }
                }
              },
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
              label: const Text(
                'Log In with email and password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'forgottenPassword');
              },
              child: const Text(
                'Did you forget your password? Tap here.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
