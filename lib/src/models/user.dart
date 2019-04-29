import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:queries/collections.dart';
import 'package:reazzon/src/models/reazzon.dart';

class User {
  FirebaseUser _firebaseUser;
  String _userId;
  String _emailAddress;
  String _firstName;
  String _lastName;
  String _userName;
  Set<Reazzon> _selectedReazzons = new Set<Reazzon>();

  String get userId => _userId;
  String get emailAddress => _emailAddress;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get userName => _userName;
  Set<Reazzon> get selectedReazzons => _selectedReazzons;
  
  User(FirebaseUser authenticatedUser) {
    _userId = authenticatedUser.uid;
    _emailAddress = authenticatedUser.email;
    _firebaseUser = authenticatedUser;

    var _collection = Collection();

    if(authenticatedUser.displayName != null){
      authenticatedUser.displayName
        .split(' ')
        .forEach((f) => _collection.add(f));
      
      if(_collection.any()){
        _firstName = _collection.elementAtOrDefault(0);
        _lastName = _collection.elementAtOrDefault(1);
        _userName = _collection.elementAtOrDefault(2);
      }
    }
  }

  bool hasCreatedUser() 
    => _firebaseUser != null;
  
  bool hasUserName()
    => _userName != null;

  Future<void> updateDetails(String firstName, String lastName, String userName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = firstName + ' ' + lastName + ' ' + userName;
    
    await _firebaseUser.updateProfile(userInfo);
    _firstName = firstName;
    _lastName = lastName;
    _userName = userName;
  }

  void addSelectedReazzons(Reazzon selectedReazzons)
  {
    _selectedReazzons.add(selectedReazzons);
  }

  Map<String, dynamic> toMap()
  {
    var map = new Map<String, dynamic>();

    if(_userId != null){
      map['userId'] = _userId;
    }
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['userName'] = _userName;
    map['reazzons'] = _selectedReazzons.map((r) => r.value).toList();

    return map;
  }
}