import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/login_and_register_logic.dart';
import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/routing/routing_constants.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/text.dart';
import '../../reusable_widgets/text_field.dart';
import '../../text/login_text.dart';
import 'authentification_base_mixin_class.dart';

class LogInPageEmailAndPassword extends StatefulWidget {
  const LogInPageEmailAndPassword({Key? key}) : super(key: key);

  @override
  State<LogInPageEmailAndPassword> createState() => _LogInPageEmailAndPasswordState();
}

class _LogInPageEmailAndPasswordState extends State<LogInPageEmailAndPassword> with AuthentificationBase {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(logInYourAccountAppBar),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextWidget(
            text: generalError != null ? generalError.toString() : '',
            color: Colors.red,
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
          PaddingWidget(
            type: 'symmetric',
            horizontal: 15,
            vertical: 5,
            child: Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  PaddingWidget(
                    type: 'all',
                    all: 15,
                    child: TextFieldWidget(
                      labelText: emailLabel,
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      borderType: const OutlineInputBorder(),
                      onChanged: validateEmail,
                    ),
                  ),
                  PaddingWidget(
                    type: 'symmetric',
                    horizontal: 15.0,
                    vertical: 10.0,
                    child: TextFieldWidget(
                      suffixIcon: IconButton(
                        icon: Icon(doNotShowPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        onPressed: () {
                          setState(() {
                            doNotShowPassword = !doNotShowPassword;
                          });
                        },
                      ),
                      borderType: const OutlineInputBorder(),
                      onChanged: (_) {},
                      obscureText: doNotShowPassword,
                      maxLines: 1,
                      enableSuggestions: false,
                      autoCorrect: false,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      labelText: passwordLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PaddingWidget(
            type: 'symmetric',
            horizontal: 20.0,
            vertical: 6.0,
            child: ButtonWidget(
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
              text: const Text(logInButtonLabel),
              minimumSize: const Size.fromHeight(52),
              primaryColor: Colors.blueGrey,
              onPressed: () async {
                setState(() {
                  generalError = passwordHasMatch(passwordController.text, regexPassword);
                });
                if (validateEmail(emailController.text) == null &&
                    passwordHasMatch(passwordController.text, regexPassword) == null) {
                  final String? error = await signInWithEmailAndPassword(authenticationService,
                      _scaffoldKey.currentContext, mounted, emailController.text, passwordController.text);
                  setState(() {
                    generalError = error;
                  });
                }
              },
            ),
          ),
          PaddingWidget(
            type: 'only',
            onlyBottom: 10.0,
            child: ButtonWidget(
              primaryColor: const Color.fromRGBO(114, 140, 157, 0),
              onPressed: () {
                Navigator.pushNamed(context, ForgottenPasswordRoute);
              },
              text: TextWidget(
                text: didYouForgetPass,
                fontStyle: FontStyle.italic,
                color: Colors.greenAccent[400],
                weight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
