import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/social_login_logic.dart';
import '../../../firebase/authentication_service.dart';
import '../../../routing/routing_constants.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/text.dart';
import '../../text/login_text.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const TextWidget(text: alreadyAccountLogIn, fontSize: 15.5),
          PaddingWidget(
            type: 'symmetric',
            horizontal: 20.0,
            vertical: 6.0,
            child: ButtonWidget(
              minimumSize: const Size.fromHeight(52),
              primaryColor: Colors.blueGrey,
              onPressed: () {
                Navigator.pushNamed(context, LogInWithEmailAndPasswordRoute);
              },
              text: const TextWidget(text: logInButtonLabel, fontSize: 17.0),
              icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
            ),
          ),
          const TextWidget(text: logInWithOtherServices, fontSize: 15.5),
          PaddingWidget(
              type: 'symmetric',
              horizontal: 20.0,
              vertical: 6.0,
              child: ButtonWidget(
                icon: const FaIcon(FontAwesomeIcons.google),
                minimumSize: const Size.fromHeight(52),
                primaryColor: Colors.redAccent,
                onPressed: () async {
                  googleSignIn(_scaffoldKey.currentContext, authenticationService, mounted);
                },
                text: const TextWidget(text: logInWithGoogle, fontSize: 17),
              )),
          PaddingWidget(
              type: 'symmetric',
              horizontal: 20.0,
              vertical: 6.0,
              child: ButtonWidget(
                icon: const FaIcon(FontAwesomeIcons.facebook),
                minimumSize: const Size.fromHeight(52),
                primaryColor: Colors.blue,
                onPressed: () async {
                  facebookSignIn(_scaffoldKey.currentContext, authenticationService, mounted);
                },
                text: const TextWidget(text: logInWithFacebook, fontSize: 17.0),
              )),
          const TextWidget(text: createANewAccountQuestion, fontSize: 15.5),
          PaddingWidget(
              type: 'only',
              onlyBottom: 20.0,
              child: PaddingWidget(
                  type: 'symmetric',
                  horizontal: 20.0,
                  vertical: 6.0,
                  child: ButtonWidget(
                    icon: const FaIcon(FontAwesomeIcons.solidUserCircle),
                    text: const TextWidget(text: createANewAccount, fontSize: 17.0),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPageRoute);
                    },
                    minimumSize: const Size.fromHeight(52),
                  ))),
        ],
      ),
    );
  }
}
