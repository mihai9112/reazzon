
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/repositories/authentication_repository.dart';
import 'package:matcher/matcher.dart';

import '../mocks/firebase_mock.dart';

void main() {
  group('AuthenticationRepository', () {
    FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
    GoogleSignInMock googleSignInMock = GoogleSignInMock();
    FacebookSignInMock facebookSignInMock = FacebookSignInMock();

    AuthenticationRepository userRepository = AuthenticationRepository(
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
      expect(await userRepository.signInWithGoogle(), firebaseUserMock);
      verify(googleSignInMock.signIn()).called(1);
      verify(googleSignInAccountMock.authentication).called(1);
    });

    test('getCurrentUser return current user', () async {
      when(firebaseAuthMock.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await userRepository.getUser(), "johndoe@mail.com");
    });

    test('isSignedIn return true only when FirebaseAuth has a user', () async {
      when(firebaseAuthMock.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
      expect(await userRepository.isSignedIn(), true);
      when(firebaseAuthMock.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
      expect(await userRepository.isSignedIn(), false);
    });

    test('signInWithCredentials returns a Firebase user', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(email: "johndoe@mail.com", password: "testpassword"))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser = await userRepository.signInWithCredentials("johndoe@mail.com", "testpassword");
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signUpWithCredentials returns a Firebase user', () async {
      when(firebaseAuthMock.createUserWithEmailAndPassword(email: "johndoe@mail.com", password: "testpassword"))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser =  await userRepository.signUpWithCredentials("johndoe@mail.com", "testpassword");
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signInWithFacebook returns a Firebase user', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultMock>.value(facebookLoginResultMock));
      
      when(firebaseAuthMock.signInWithCredential(any))
        .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      final returnedUser =  await userRepository.signInWithFacebook();
      expect(returnedUser.email, firebaseUserMock.email);
    });

    test('signinWithFacebook returns FacebookLoginStatus of Error', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultErrorMock>.value(facebookLoginResultErrorMock));

      expect(() async => await userRepository.signInWithFacebook(), throwsA(TypeMatcher<StateError>()));
    });

    test('signInWithFacebook returns FacebookLoginStatus of CancelledByUser', () async {
      when(facebookSignInMock.logIn(['email']))
        .thenAnswer((_) => Future<FacebookLoginResultCancelledByUserMock>.value(facebookLoginResultCancelledByUserMock));

      expect(() async => await userRepository.signInWithFacebook(), throwsA(TypeMatcher<StateError>()));
    });
  });
}