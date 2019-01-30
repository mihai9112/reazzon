import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser _firebaseUser;
  String _userId;
  String _emailAddress;
  String _firstName;
  String _lastName;
  String _userName;
  List<String> _selectedReazzons;

  String get userId => _userId;
  String get emailAddress => _emailAddress;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get userName => _userName;
  FirebaseUser get firebaseUser => _firebaseUser;
  List<String> get selectedReazzons => _selectedReazzons;
  
  User(FirebaseUser authenticatedUser) {
    _userId = authenticatedUser.uid;
    _emailAddress = authenticatedUser.email;
    _firebaseUser = authenticatedUser;
  }

  Future<void> updateDetails(String firstName, String lastName, String userName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = firstName + '||' + lastName + '||' + userName;
    
    await _firebaseUser.updateProfile(userInfo);

    _firstName = firstName;
    _lastName = lastName;
    _userName = userName;
  }

  void addSelectedReazzons(List<String> selectedReazzons)
  {
    _selectedReazzons = selectedReazzons;
  }
}