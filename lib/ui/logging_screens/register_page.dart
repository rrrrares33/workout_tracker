import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/authentication_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers for textFields.
  // One for email and one for password.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  // Whether it should hide content of the TextField field.
  late bool _doNotShowPassword = true;

  // Regex expression for email.
  final RegExp _regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Between 8 and 20 characters, at least one uppercase letter, one lowercase letter,
  //    one number and one special character:
  final RegExp _regexPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[.,@$!%*?&])[A-Za-z\d@$!.,%*?&]{8,20}$');

  String? _emailWarning;

  String? _generalError;

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
                        if (text != '' && !_regexEmail.hasMatch(text)) {
                          setState(() {
                            _generalError = null;
                            _emailWarning = 'Email is not valid.';
                          });
                        } else {
                          setState(() {
                            _emailWarning = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Email ...',
                        errorText: _emailWarning,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextField(
                      obscureText: _doNotShowPassword,
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
                      obscureText: _doNotShowPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordConfirmController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Confirm password...',
                        suffixIcon: IconButton(
                          icon: Icon(_doNotShowPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
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
          Text(
            _generalError != null ? _generalError.toString() : '',
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () async {
                  setState(() {
                    if (passwordConfirmController.text != passwordController.text) {
                      _generalError = 'The passwords do not match.';
                    } else if (!_regexPassword.hasMatch(passwordController.text)) {
                      _generalError = 'This account does not exist.';
                    } else {
                      _generalError = null;
                    }
                  });
                  if (_emailWarning == null && passwordController.text != '' && _generalError == null) {
                    try {
                      await authenticationService.createNewUser(emailController.text, passwordController.text);
                      Future<dynamic>.delayed(Duration.zero).then((_) {
                        Navigator.of(context).pop();
                      });
                    } catch (exception) {
                      setState(() {
                        _generalError = 'This email is already in use.';
                      });
                    }
                  }
                },
                child: const Text(
                  'Register',
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
