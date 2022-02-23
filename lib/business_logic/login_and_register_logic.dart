import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ui/pages/entry_form/check_first_time_and_load_db_intermediary.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/text/login_text.dart';
import '../utils/firebase/authentication_service.dart';
import '../utils/firebase/database_service.dart';
import '../utils/models/user_auth.dart';
import '../utils/models/user_database.dart';

Widget returnIfUserConnected(User? user) {
  if (user == null) {
    return const LogInPage();
  }
  return CheckFirstTimeAndLoadDB(loggedUserUid: user.getUid, loggedEmail: user.getEmail);
}

UserDB? getUserOrCreateIfNullUsingUID(DatabaseService db, String loggedUserUid, String loggedEmail) {
  UserDB? loggedUser = db.getUserBaseOnUid(loggedUserUid);
  if (loggedUser != null) {
    return loggedUser;
  }
  db.createUserBeforeDetails(loggedUserUid, loggedEmail);
  loggedUser = UserDB(loggedUserUid, loggedEmail, true);
  return loggedUser;
}

String? validateEmail(String? content) {
  // Regex expression for email.
  final RegExp regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if (content!.isEmpty || regexEmail.hasMatch(content)) {
    return null;
  }
  return emailNotValid;
}

bool testCapital(String? content) {
  return content.toString().toLowerCase() != content.toString();
}

Color? pickColorRightWrong(bool aux) {
  if (aux) return Colors.greenAccent[400];
  return Colors.red;
}

Widget? pickIconRightWrong(bool aux) {
  if (aux) return Icon(FontAwesomeIcons.checkCircle, size: 14, color: Colors.greenAccent[400]);
  return const Icon(FontAwesomeIcons.solidTimesCircle, size: 14, color: Colors.red);
}

bool testLower(String? content) {
  return content.toString().toUpperCase() != content.toString();
}

bool testNumbers(String? content) {
  final RegExp regexNumbers = RegExp(r'[10-99]');
  return regexNumbers.hasMatch(content.toString());
}

bool testSymbol(String? content) {
  return content.toString().replaceAll(RegExp(r'[^\w\s]+'), '') != content.toString();
}

bool verifyRegistrationFilled(
    bool symbol, bool number, bool capital, bool lower, bool passMatch, String email, String password) {
  return symbol && number && capital && lower && passMatch && validateEmail(email) == null && password.isNotEmpty;
}

Future<void> registerNewAccount(AuthenticationService authenticationService, BuildContext? context, String email,
    String password, bool mounted) async {
  try {
    await authenticationService.createNewUser(email, password);
    if (!mounted) return;
    ScaffoldMessenger.of(context!).showSnackBar(registerComplete);
    Navigator.of(context).pop();
  } catch (exception) {
    ScaffoldMessenger.of(context!).showSnackBar(registerFailed);
  }
}

void sendRecoveryEmail(AuthenticationService authenticationService, BuildContext? context, String email) {
  authenticationService.resetPassword(email);
  ScaffoldMessenger.of(context!).showSnackBar(recoveryEmailSent);
  Navigator.of(context).pop();
}

String? passwordHasMatch(String password, RegExp regex) {
  if (!regex.hasMatch(password)) {
    return accountDoesNotExist;
  }
  return null;
}

Future<String?> signInWithEmailAndPassword(AuthenticationService authenticationService, BuildContext? context,
    bool mounted, String email, String password) async {
  try {
    await authenticationService.signInUserEmailPassword(email, password);
    if (!mounted) return null;
    ScaffoldMessenger.of(context!).showSnackBar(loggedInSuccess);
    Future<dynamic>.delayed(Duration.zero).then((_) {
      Navigator.of(context).pop();
    });
    return null;
  } catch (exception) {
    return accountDoesNotExist;
  }
}
