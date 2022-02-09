class User {
  User(this._uid, this._email);

  final String _uid;
  final String _email;

  String get getEmail {
    return _email;
  }

  String get getUid {
    return _uid;
  }
}
