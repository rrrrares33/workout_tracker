import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/authentication_service.dart';
import '../ui/text/login_text.dart';

Future<void> googleSignIn(BuildContext? context, AuthenticationService authenticationService, bool mounted) async {
  try {
    await authenticationService.signInWithGoogle();
    if (!mounted) return;
    ScaffoldMessenger.of(context!).showSnackBar(loggedSuccessful);
  } on FirebaseAuthException catch (e) {
    if (e.message != null) {
      final SnackBar failedLoginSnackBar = SnackBar(content: Text('Google ${e.message ?? ''}'));
      ScaffoldMessenger.of(context!).showSnackBar(failedLoginSnackBar);
    }
  }
}

Future<void> facebookSignIn(BuildContext? context, AuthenticationService authenticationService, bool mounted) async {
  try {
    await authenticationService.signInWithFacebook();
    if (!mounted) return;
    ScaffoldMessenger.of(context!).showSnackBar(loggedInSuccess);
  } on FirebaseAuthException catch (e) {
    if (e.message != null) {
      final SnackBar failedLoginSnackBar = SnackBar(content: Text('Facebook ${e.message ?? ''}'));
      ScaffoldMessenger.of(context!).showSnackBar(failedLoginSnackBar);
    }
  }
}
