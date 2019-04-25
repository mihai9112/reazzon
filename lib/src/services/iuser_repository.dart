import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/user.dart';

abstract class IUserRepository {
  Future<bool> createUserDetails(User user);
  Stream<QuerySnapshot> getUserDetails({int offset, int limit});
  Future<bool> updateUserDetails(User user);
  Future<bool> deleteUserDetails(User user);
}