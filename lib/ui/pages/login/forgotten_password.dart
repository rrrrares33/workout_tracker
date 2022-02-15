import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authentication_service.dart';
import 'authentification_base.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({Key? key}) : super(key: key);

  @override
  ForgottenPasswordState createState() => ForgottenPasswordState();
}

class ForgottenPasswordState extends State<ForgottenPassword> with AuthentificationBase {
  static const SnackBar emailSent = SnackBar(content: Text('Recovery email is on the way!'));

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
          title: const Text('Enter your email here'),
          centerTitle: true,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(children: <Widget>[
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
                  ]))),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(52),
                  primary: Colors.blueGrey,
                ),
                onPressed: () async {
                  authenticationService.resetPassword(emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(emailSent);
                  Navigator.of(context).pop();
                },
                icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                label: const Text(
                  'Send email to reset password.',
                ),
              ),
            ),
          ),
        ]));
  }
}
