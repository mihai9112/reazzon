import 'dart:async';

import 'package:reazzon/src/models/user.dart';

abstract class IUserRepository {
  Future<void> addUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
}