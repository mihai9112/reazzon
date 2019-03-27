import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/IUserRepository.dart';

class UserRepository implements IUserRepository{
  DocumentReference _userRef;
  Firestore database = new Firestore();

  static final UserRepository _instance = 
    new UserRepository.internal();

  UserRepository.internal();

  factory UserRepository() => _instance;

  void initState() {
    _userRef = database.document('users');
  }

  @override
  Future<void> addUser(User user) async {
    await _userRef.setData(<String, String>{
      "firstName": user.firstName,
      "lastName": user.lastName,
      "userName": user.userName
    }).then((_){
      print('Transaction commited');
    });
  }

  @override
  Future<void> deleteUser(User user) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    return null;
  }
}