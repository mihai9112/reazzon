import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser _firebaseUser;
  String _userId;
  String _emailAddress;

  String get userId => _userId;
  String get emailAddress => _emailAddress;
  
  User(FirebaseUser authenticatedUser) {
    _userId = authenticatedUser.uid;
    _emailAddress = authenticatedUser.email;
    _firebaseUser = authenticatedUser;
  }

  Future<void> updateDetails(String firstName, String lastName, String userName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = firstName + '||' + lastName + '||' + userName;
    
    await _firebaseUser.updateProfile(userInfo);
  }

}