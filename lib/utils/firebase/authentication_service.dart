import 'package:firebase_auth/firebase_auth.dart' as authentication;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_auth.dart';

class AuthenticationService {
  // We generate an instance of Firebase authentication service and keep it in _firebaseAuth private variable.
  final authentication.FirebaseAuth _firebaseAuth = authentication.FirebaseAuth.instance;

  // Gets an user(based on its credentials) from firebase cloud.
  User? _getUserFromFirebase(authentication.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email ?? '');
  }

  // User getter.
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_getUserFromFirebase);
  }

  // Signs In the application a user based on its email and password.
  // It returns the user details.
  Future<User?> signInUserEmailPassword(String email, String password) async {
    final authentication.UserCredential credentials =
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _getUserFromFirebase(credentials.user);
  }

  // In case of forgotten password, this should do the trick to retrieve it.
  // ignore: avoid_void_async
  void resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Signs in or registers an user automatically based on his google account.
  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final authentication.OAuthCredential credential = authentication.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final authentication.UserCredential credentials = await _firebaseAuth.signInWithCredential(credential);

    // Once signed in, return the UserCredential
    return _getUserFromFirebase(credentials.user);
  }

  Future<User?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final authentication.OAuthCredential facebookAuthCredential =
        authentication.FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final authentication.UserCredential credentials = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

    // Once signed in, return the UserCredential
    return _getUserFromFirebase(credentials.user);
  }

  // Creates a new user and adds it to the firebase cloud. (based on email and password provided)
  // It returns the user details.
  Future<User?> createNewUser(String email, String password) async {
    final authentication.UserCredential credentials =
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _getUserFromFirebase(credentials.user);
  }

  // Signs out a user from firebase cloud.
  Future<void> signOutFromFirebase() async {
    return _firebaseAuth.signOut();
  }
}
