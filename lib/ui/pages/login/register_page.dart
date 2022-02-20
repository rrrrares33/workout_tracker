import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/login_and_register_logic.dart';
import '../../../firebase/authentication_service.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/text_field.dart';
import '../../text/login_text.dart';
import 'authentification_base.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with AuthentificationBase {
  final TextEditingController _passwordConfirmController = TextEditingController();
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static bool hasCapital = false;
  static bool hasLower = false;
  static bool hasNumbers = false;
  static bool hasSymbol = false;
  static bool passwordsMatch = false;

  @override
  Widget build(BuildContext context) {
    // Get authentication service from Provider.
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(_scaffoldKey.currentContext!).pop(),
        ),
        title: const Text(registerAccountAppBar),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PaddingWidget(
                type: 'symmetric',
                horizontal: 15.0,
                vertical: 10.0,
                child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: TextFieldWidget(
                          controller: emailController,
                          keyboardType: TextInputType.name,
                          labelText: emailLabel,
                          borderType: const OutlineInputBorder(),
                          onChangedCustom: validateEmail,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: TextFieldWidget(
                          obscureText: doNotShowPassword,
                          enableSuggestions: false,
                          autoCorrect: false,
                          borderType: const OutlineInputBorder(),
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
                                hasCapital = testCapital(passwordController.text);
                                hasLower = testLower(passwordController.text);
                                hasNumbers = testNumbers(passwordController.text);
                                hasSymbol = testSymbol(passwordController.text);
                                passwordsMatch = passwordController.text == _passwordConfirmController.text;
                              });
                            }
                          },
                          keyboardType: TextInputType.name,
                          labelText: passwordLabel,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: TextFieldWidget(
                          obscureText: doNotShowPassword,
                          enableSuggestions: false,
                          autoCorrect: false,
                          borderType: const OutlineInputBorder(),
                          controller: _passwordConfirmController,
                          keyboardType: TextInputType.name,
                          onChanged: (_) {
                            setState(() {
                              passwordsMatch = passwordController.text == _passwordConfirmController.text;
                            });
                          },
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
                    ],
                  ),
                ),
              ),
              PaddingWidget(
                type: 'symmetric',
                horizontal: 45.0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: pickColorRightWrong(hasLower),
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: PaddingWidget(
                            type: 'only',
                            onlyBottom: 2.5,
                            child: pickIconRightWrong(hasLower),
                          ),
                        ),
                        const TextSpan(
                          text: passwordLowerChecker,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PaddingWidget(
                type: 'symmetric',
                horizontal: 45.0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: pickColorRightWrong(hasCapital),
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: PaddingWidget(
                            type: 'only',
                            onlyBottom: 2.5,
                            child: pickIconRightWrong(hasCapital),
                          ),
                        ),
                        const TextSpan(
                          text: passwordCapitalChecker,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PaddingWidget(
                type: 'symmetric',
                horizontal: 45.0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: pickColorRightWrong(hasNumbers),
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: PaddingWidget(
                            type: 'only',
                            onlyBottom: 2.5,
                            child: pickIconRightWrong(hasNumbers),
                          ),
                        ),
                        const TextSpan(
                          text: passwordNumberChecker,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PaddingWidget(
                type: 'symmetric',
                horizontal: 45.0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: pickColorRightWrong(hasSymbol),
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: PaddingWidget(
                            type: 'only',
                            onlyBottom: 2.5,
                            child: pickIconRightWrong(hasSymbol),
                          ),
                        ),
                        const TextSpan(
                          text: passwordSymbolChecker,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PaddingWidget(
                type: 'symmetric',
                horizontal: 45.0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: pickColorRightWrong(passwordsMatch),
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: PaddingWidget(
                            type: 'only',
                            onlyBottom: 2.5,
                            child: pickIconRightWrong(passwordsMatch),
                          ),
                        ),
                        const TextSpan(
                          text: '  Password and confirm are equal.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PaddingWidget(
                onlyBottom: 20.0,
                type: 'only',
                child: PaddingWidget(
                    type: 'symmetric',
                    horizontal: 20.0,
                    vertical: 6.0,
                    child: ButtonWidget(
                      icon: const FaIcon(FontAwesomeIcons.solidUserCircle),
                      text: const Text(createANewAccount),
                      fontSize: 17.0,
                      onPressed: () async {
                        if (verifyRegistrationFilled(hasSymbol, hasNumbers, hasCapital, hasLower, passwordsMatch,
                            emailController.text, passwordController.text)) {
                          await registerNewAccount(authenticationService, _scaffoldKey.currentContext,
                              emailController.text, passwordController.text, mounted);
                        }
                      },
                      minimumSize: const Size.fromHeight(52),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
