import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import 'authentification_base.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with AuthentificationBase {
  final TextEditingController _passwordConfirmController = TextEditingController();
  static const SnackBar registerComplete = SnackBar(content: Text('You have successfully created a new account!'));

  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create a new account'),
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
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Password...',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextField(
                      obscureText: doNotShowPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _passwordConfirmController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Confirm password...',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Center(
              child: Text(
                generalError != null ? generalError.toString() : '',
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () async {
                  setState(() {
                    if (_passwordConfirmController.text != passwordController.text) {
                      generalError = 'The passwords do not match.';
                    } else if (!regexPassword.hasMatch(passwordController.text)) {
                      generalError =
                          'Password need to contain at least one uppercase letter, one lower case letter and one symbol.';
                    } else {
                      generalError = null;
                    }
                  });
                  if (emailWarning == null && passwordController.text != '' && generalError == null) {
                    try {
                      await authenticationService.createNewUser(emailController.text, passwordController.text);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(registerComplete);
                      Future<dynamic>.delayed(Duration.zero).then((_) {
                        Navigator.of(context).pop();
                      });
                    } catch (exception) {
                      setState(() {
                        generalError = 'This email is already in use.';
                      });
                    }
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.solidUserCircle),
                label: const Text(
                  'Register a new local account.',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
