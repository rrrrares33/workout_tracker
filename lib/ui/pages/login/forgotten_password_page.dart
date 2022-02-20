import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/login_and_register_logic.dart';
import '../../../firebase/authentication_service.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/text.dart';
import '../../reusable_widgets/text_field.dart';
import '../../text/login_text.dart';
import 'authentification_base.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({Key? key}) : super(key: key);

  @override
  ForgottenPasswordState createState() => ForgottenPasswordState();
}

class ForgottenPasswordState extends State<ForgottenPassword> with AuthentificationBase {
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
          title: const TextWidget(text: emailEnterHere, fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          PaddingWidget(
              type: 'symmetric',
              horizontal: 15.0,
              vertical: 10.0,
              child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(children: <Widget>[
                    PaddingWidget(
                      type: 'all',
                      all: 15.0,
                      child: TextFieldWidget(
                        labelText: emailLabel,
                        borderType: const OutlineInputBorder(),
                        controller: emailController,
                        keyboardType: TextInputType.name,
                        onChanged: validateEmail,
                      ),
                    ),
                  ]))),
          PaddingWidget(
            type: 'only',
            onlyBottom: 20.0,
            onlyLeft: 20.0,
            onlyRight: 20.0,
            onlyTop: 6.0,
            child: ButtonWidget(
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
              primaryColor: Colors.blueGrey,
              minimumSize: const Size.fromHeight(52),
              onPressed: () {
                sendRecoveryEmail(authenticationService, _scaffoldKey.currentContext, emailController.text);
              },
              text: const TextWidget(text: emailRecoveryButton, color: Colors.white, fontSize: 17,),
            ),
          ),
        ]));
  }
}
