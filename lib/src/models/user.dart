import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser _firebaseUser;
  String _userId;
  String _emailAddress;

  String get userId => _userId;
  String get emailAddress => _emailAddress;
  FirebaseUser get firebaseUser => _firebaseUser;
  
  User(FirebaseUser authenticatedUser) {
    _userId = authenticatedUser.uid;
    _emailAddress = authenticatedUser.email;
    _firebaseUser = authenticatedUser;
  }

}