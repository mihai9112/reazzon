import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';

import '../helpers/shared_preferences.dart';
import 'authentication_firebase_mock.dart';

void main() {
  group('AuthenticationRepository', () {
    FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
    GoogleSignInMock googleSignInMock = GoogleSignInMock();
    FacebookSignInMock facebookSignInMock = FacebookSignInMock();

    AuthenticationRepository authenticationRepository = AuthenticationRepository(
      firebaseAuth: firebaseAuthMock,
      googleSignin: googleSignInMock,
      facebookSignIn: facebookSignInMock
    );

    final GoogleSignInAccountMock googleSignInAccountMock = 
      GoogleSignInAccountMock();
    final GoogleSignInAuthenticationMock googleSignInAuthenticationMock = 
      GoogleSignInAuthenticationMock();
    final FirebaseUserMock firebaseUserMock = FirebaseUserMock();
    final FacebookLoginResultMock facebookLoginResultMock = 
      FacebookLoginResultMock();
    final FacebookLoginResultErrorMock facebookLoginResultErrorMock =
      FacebookLoginResultErrorMock();
    final FacebookLoginResultCancelledByUserMock facebookLoginResultCancelledByUserMock = 
      FacebookLoginResultCancelledByUserMock();
    final AuthResultMock authResultMock = AuthResultMock();
    CachedPreferencesMock cachedPreferencesMock = CachedPreferencesMock();
    SharedObjects.prefs = cachedPreferencesMock;

    test('signInWithGoogle returns a Firebase user', () async {
      when(googleSignInMock.signIn()).thenAnswer(
        (_) => Future<GoogleSignInAccountMock>.value(googleSignInAccountMock));
      when(googleSignInAccountMock.authentication).thenAnswer((_) =>
        Future<GoogleSignInAuthenticationMock>.value(
          googleSignInAuthenticationMock
        ));
      when(firebaseAuthMock.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));

      //call the method and expect the Firebase user as return
      expect(await authenticationRepository.signInWithGoogle(), firebaseUserMock);
      verify(googleSignInMock.signIn()).called(1);
      verify(googleSignInAccountMock.authentication).called(1);
    });

    test('getCurrentUser return current user', () async {
      when(firebaseAuthMock.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await authenticationRepository.getUser(), firebaseUserMock);
    });

    test('isSignedIn return true only when FirebaseAuth has a user', () async {
      when(firebaseAuthMock.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await authenticationRepository.isSignedIn(), true);
      when(firebaseAuthMock.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
      expect(await authenticationRepository.isSignedIn(), false);
    });

    test('signInWithCredentials returns a Firebase user', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(email: "johndoe@mail.com", password: "testpassword"))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser = await authenticationRepository.signInWithCredentials("johndoe@mail.com", "testpassword");
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signUpWithCredentials returns a Firebase user', () async {
      when(firebaseAuthMock.createUserWithEmailAndPassword(email: "johndoe@mail.com", password: "testpassword"))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser =  await authenticationRepository.signUpWithCredentials("johndoe@mail.com", "testpassword");
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signInWithFacebook returns a Firebase user', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultMock>.value(facebookLoginResultMock));
      
      when(firebaseAuthMock.signInWithCredential(any))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser =  await authenticationRepository.signInWithFacebook();
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signinWithFacebook returns FacebookLoginStatus of Error', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultErrorMock>.value(facebookLoginResultErrorMock));

      expect(() async => await authenticationRepository.signInWithFacebook(), throwsA(TypeMatcher<StateError>()));
    });

    test('signInWithFacebook returns FacebookLoginStatus of CancelledByUser', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultCancelledByUserMock>.value(facebookLoginResultCancelledByUserMock));

      expect(() async => await authenticationRepository.signInWithFacebook(), throwsA(TypeMatcher<StateError>()));
    });
  });
}