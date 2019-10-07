import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth{}
class GoogleSignInMock extends Mock implements GoogleSignIn{}
class FacebookSignInMock extends Mock implements FacebookLogin{}
class AuthCredentialMock extends Mock implements AuthCredential{}
class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount{}

class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication{
  @override
  String get accessToken => 'mock_access_token';
  @override
  String get idToken => 'mock_id_token';
}

class FirebaseUserMock extends Mock implements FirebaseUser{
  @override
  String get displayName => 'John Doe';
  @override
  String get uid => 'uid';
  @override
  String get email => 'johndoe@mail.com';
  @override
  String get photoUrl => 'http://www.adityag.me';
}

class FacebookLoginResultMock extends Mock implements FacebookLoginResult {
  @override
  FacebookLoginStatus get status => FacebookLoginStatus.loggedIn;
  @override
  FacebookAccessToken get accessToken => FacebookAccessToken.fromMap({ 'token': 'mock_access_token' });
}