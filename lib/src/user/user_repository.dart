import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/user/user.dart';
import 'package:reazzon/src/user/user_data_provider.dart';

class UserRepository {
  final UserDataProvider _userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromProvider(FirebaseUser user) =>
    _userDataProvider.saveDetailsFromProvider(user);
  
  Future<bool> isProfileComplete() => _userDataProvider.isProfileComplete();
}