import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import '../../text/login_text.dart';
import 'authentification_base.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with AuthentificationBase {
  final TextEditingController _passwordConfirmController = TextEditingController();
  static bool hasCapital = false;
  static bool hasLower = false;
  static bool hasNumbers = false;
  static bool hasSymbol = false;
  static bool passwordsMatch = false;

  static final RegExp regexNumbers = RegExp(r'[10-99]');

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
        title: const Text(registerAccountAppBar),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                                emailWarning = emailNotValid;
                              });
                            } else {
                              setState(() {
                                generalError = null;
                                emailWarning = null;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            labelText: emailLabel,
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
                          onChanged: (_) {
                            if (passwordController.text.isEmpty) {
                              setState(() {
                                hasCapital = false;
                                hasLower = false;
                                hasNumbers = false;
                                hasSymbol = false;
                                passwordsMatch = false;
                              });
                            } else {
                              setState(() {
                                hasCapital = passwordController.text.toLowerCase() != passwordController.text;
                                hasLower = passwordController.text.toUpperCase() != passwordController.text;
                                hasNumbers = regexNumbers.hasMatch(passwordController.text);
                                hasSymbol = passwordController.text.replaceAll(RegExp(r'[^\w\s]+'), '') !=
                                    passwordController.text;
                                passwordsMatch = passwordController.text == _passwordConfirmController.text;
                              });
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            labelText: passwordLabel,
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
                          onChanged: (_) {
                            if (_passwordConfirmController.text.isEmpty) {
                              setState(() {
                                passwordsMatch = passwordController.text == _passwordConfirmController.text;
                              });
                            } else {
                              setState(() {
                                passwordsMatch = passwordController.text == _passwordConfirmController.text;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            labelText: confirmPasswordLabel,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: hasLower ? Colors.greenAccent[400] : Colors.red,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          // child: Icon(FontAwesomeIcons.timesCircle, size: 14, color: Colors.greenAccent[400]),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: hasLower
                                ? Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400])
                                : const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red),
                          ),
                        ),
                        const TextSpan(
                          text: passwordLowerChecker,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: hasCapital ? Colors.greenAccent[400] : Colors.red,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: hasCapital
                                ? Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400])
                                : const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red),
                          ),
                        ),
                        const TextSpan(
                          text: passwordCapitalChecker,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: hasNumbers ? Colors.greenAccent[400] : Colors.red,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: hasNumbers
                                ? Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400])
                                : const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red),
                          ),
                        ),
                        const TextSpan(text: passwordNumberChecker),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: hasSymbol ? Colors.greenAccent[400] : Colors.red,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: hasSymbol
                                ? Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400])
                                : const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red),
                          ),
                        ),
                        const TextSpan(text: passwordSymbolChecker),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: passwordsMatch ? Colors.greenAccent[400] : Colors.red,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: passwordsMatch
                                ? Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400])
                                : const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red),
                          ),
                        ),
                        const TextSpan(text: '  Password and confirm are equal.'),
                      ],
                    ),
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
                      if (hasSymbol && hasNumbers && hasCapital && hasLower && passwordsMatch) {
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
                              generalError = emailAlreadyInUse;
                            });
                          }
                        }
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.solidUserCircle),
                    label: const Text(
                      createANewAccount,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
