import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/services/IAuthentication.dart';

class Authentication implements IAuthentication {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  Future<String> getCurrentUser() {
    // TODO: implement getCurrentUser
    return null;
  }

  @override
  Future<String> signIn(String email, String password) async {

    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return null;
  }

  @override
  Future<String> signUp(String email, String password) async {
    
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

}