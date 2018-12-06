import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/services/IAuthentication.dart';

class FirebaseAuthentication  implements IAuthentication{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> getCurrentUser() {
    // TODO: implement getCurrentUser
    return null;
  }

  @override
  Future<bool> signIn(String email, String password) {
    // TODO: implement signIn
    return null;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return null;
  }

  @override
  Future<FirebaseUser> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
  
}

FirebaseAuthentication firebaseAuthentication = new FirebaseAuthentication();