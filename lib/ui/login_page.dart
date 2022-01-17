import 'package:flutter/material.dart';
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
  // final RegExp _regexPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');

  String? _emailWarning;
  // final String _passwordWarning = '';

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
            padding: const EdgeInsetsDirectional.all(20),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.name,
              onChanged: (String text) {
                if (text == '' || !_regexEmail.hasMatch(text)) {
                  _emailWarning = 'Email is not valid.';
                } else {
                  _emailWarning = null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Email ...',
                errorText: _emailWarning,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: TextField(
              obscureText: _doNotShowPassword,
              enableSuggestions: false,
              autocorrect: false,
              controller: passwordController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Password...',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (_emailWarning == null &&
                          passwordController.text != '')
                        // print('here');
                        authenticationService.signInUserEmailPassword(
                            emailController.text, passwordController.text);
                    },
                    child: const Text('Log In')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: const Text('Register')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
