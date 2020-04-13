import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth{}
class GoogleSignInMock extends Mock implements GoogleSignIn{}
class FacebookSignInMock extends Mock implements FacebookLogin{}
class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount{}
class AuthCredentialMock extends Mock implements AuthCredential{}

class FacebookAccessTokenMock extends Mock implements FacebookAccessToken{
  @override 
  String get token => 'mock_facebook_token';
}

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

class AuthResultMock extends Mock implements AuthResult {
  @override
  FirebaseUser get user => FirebaseUserMock();
}

class FacebookLoginResultMock extends Mock implements FacebookLoginResult {
  @override
  FacebookLoginStatus get status => FacebookLoginStatus.loggedIn;
  @override
  FacebookAccessToken get accessToken => FacebookAccessTokenMock();
}

class FacebookLoginResultErrorMock extends Mock implements FacebookLoginResult {
  @override
  FacebookLoginStatus get status => FacebookLoginStatus.error;
  @override
  String get errorMessage => 'error message';
}

class FacebookLoginResultCancelledByUserMock extends Mock implements FacebookLoginResult {
  @override
  FacebookLoginStatus get status => FacebookLoginStatus.cancelledByUser;
}