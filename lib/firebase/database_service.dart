import 'package:firebase_database/firebase_database.dart';
import '../../models/user_database.dart';

class DatabaseService {
  DatabaseService() {
    _firebaseDB = FirebaseDatabase.instance;
    _usersRef = _firebaseDB.ref().child('Users');
  }

  // Here I try to initialize everything from the database into the app,
  //  so it will be easier for the program to process everything without
  //  waiting times.
  Future<bool> initializeEntities() async {
    // Starts loading database data.
    _allUsers = await getAllUsers();
    return true;
  }

  // We store the instance of the database in a private param.
  late final FirebaseDatabase _firebaseDB;
  late final DatabaseReference _usersRef;

  //_usersRef = _firebaseDB.ref().child('users').set("salam");

  List<UserDB> _allUsers = <UserDB>[];

  List<UserDB> getUsers() {
    return _allUsers;
  }

  // Gets all current users from database.
  // It is called only once at the start of the application.
  Future<List<UserDB>> getAllUsers() async {
    //This method should return all users store in the database.
    //If there is no user, it will return an empty list.

    final List<UserDB> users = <UserDB>[];
    final DatabaseEvent event = await _usersRef.once();
    if (event.snapshot.value == null) {
      return <UserDB>[];
    }
    // ignore: cast_nullable_to_non_nullable
    final Map<dynamic, dynamic> result = event.snapshot.value as Map<dynamic, dynamic>;
    if (result.isEmpty) {
      return <UserDB>[];
    }
    result.forEach((dynamic key, dynamic value) {
      value = value as Map<dynamic, dynamic>;
      final UserDB auxUser = UserDB.fromJson(value);
      users.add(auxUser);
    });
    return users;
  }

  // Gets an user using its uid. (provided by firebase_authentication).
  UserDB? getUserBaseOnUid(String uid) {
    UserDB? foundUser;
    bool found = false;
    for (final UserDB user in _allUsers) {
      if (user.uid == uid && found == false) {
        if (user.firstEntry == true) {
          foundUser = UserDB(user.uid, user.email, user.firstEntry);
          found = true;
        } else {
          foundUser = UserDB(user.uid, user.email, user.firstEntry, user.name, user.surname, user.age, user.weight,
              user.height, user.weightType);
          found = true;
        }
      }
    }
    return foundUser;
  }

  // Creates an user before completing the details form.
  Future<void> createUserBeforeDetails(String uid, String email) async {
    await _usersRef.child(uid).set(<String, dynamic>{'uid': uid, 'email': email, 'firstEntry': true.toString()});
  }

  // Creates an user after completing the details form.
  Future<void> createUserWithFullDetails(String uid, String email, String name, String surname, int age, double weight,
      double height, WeightMetric weightType) async {
    // We first delete the already created user (firstEntry == true)
    await _usersRef.child(uid).remove();

    // Then we create the new user.
    await _usersRef.set(<String, dynamic>{
      'uid': uid,
      'email': email,
      'firstEntry': false as String,
      'name': name,
      'surname': surname,
      'age': age as String,
      'weight': weight as String,
      'height': height as String,
      'weightType': weightType as String
    });
  }
}
