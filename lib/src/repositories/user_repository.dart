import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin, FacebookLogin facebookSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookSignIn = facebookSignIn ?? FacebookLogin();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final FacebookLoginResult facebookUser = await _facebookSignIn.logIn(['email']);

    switch (facebookUser.status) {
      case FacebookLoginStatus.loggedIn :
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookUser.accessToken.token
          );
          return (await _firebaseAuth.signInWithCredential(credential)).user;
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

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookSignIn.logOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}