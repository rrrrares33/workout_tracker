import 'package:firebase_auth/firebase_auth.dart' as authentication;
import '../models/user.dart';

class AuthenticationService {
  // We generate an instance of Firebase authentication service and keep it in _firebaseAuth private variable.
  final authentication.FirebaseAuth _firebaseAuth =
      authentication.FirebaseAuth.instance;

  // Gets an user(based on its credentials) from firebase cloud.
  User? _getUserFromFirebase(authentication.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email ?? '');
  }

  // User getter.
  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_getUserFromFirebase);
  }

  // Signs In the application a user based on its email and password.
  // It returns the user details.
  Future<User?> signInUserEmailPassword(String email, String password) async {
    final authentication.UserCredential credentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return _getUserFromFirebase(credentials.user);
  }

  // Creates a new user and adds it to the firebase cloud. (based on email and password provided)
  // It returns the user details.
  Future<User?> createNewUser(String email, String password) async {
    final authentication.UserCredential credentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _getUserFromFirebase(credentials.user);
  }

  // Signs out a user from firebase cloud.
  Future<void> signOutFromFirebase() async {
    return _firebaseAuth.signOut();
  }
}
