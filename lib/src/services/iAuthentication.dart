import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthentication {
  Future<bool> signIn(String email, String password);
  Future<FirebaseUser> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}