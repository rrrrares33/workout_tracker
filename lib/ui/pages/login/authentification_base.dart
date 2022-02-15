import 'package:flutter/material.dart';

mixin AuthentificationBase {
  // Controllers for textFields.
  // One for email and one for password.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Whether it should hide content of the TextField field.
  late bool doNotShowPassword = true;

  // Regex expression for email.
  final RegExp regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Between 8 and 20 characters, at least one uppercase letter, one lowercase letter,
  //    one number and one special character:
  final RegExp regexPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[.,@$!%*?&])[A-Za-z\d@$!.,%*?&]{8,20}$');

  String? emailWarning;

  String? generalError;
}
