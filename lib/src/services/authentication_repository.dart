import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/services/iauthentication_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthenticationRepository implements IAuthenticationRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FacebookLogin _facebookLogin = FacebookLogin();

  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  @override
  Future<void> signOut() {

    // TODO: implement signOut
    return null;
  }

  @override
  Future<FirebaseUser> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    ); 
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    final facebookUser = await _facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookUser.status) {
      case FacebookLoginStatus.loggedIn :
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookUser.accessToken.token
          );
          return await _firebaseAuth.signInWithCredential(credential);
        break;
      case FacebookLoginStatus.error :
        throw StateError(facebookUser.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser :
        throw StateError("User cancelled");
        break;
      default:
        throw StateError("Unknown Facebook user state");
    }
  }
}

AuthenticationRepository firebaseAuthentication = new AuthenticationRepository();