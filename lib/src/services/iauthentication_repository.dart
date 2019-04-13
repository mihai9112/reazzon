import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthenticationRepository {
  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> signUp(String email, String password);
  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithFacebook();
  Future<void> signOut();
}