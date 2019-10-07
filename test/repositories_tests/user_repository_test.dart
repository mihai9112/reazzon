import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/repositories/user_repository.dart';

import '../mocks/firebase_mock.dart';

void main() {
  group('UserRepository', () {
    FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
    GoogleSignInMock googleSignInMock = GoogleSignInMock();
    FacebookSignInMock facebookSignInMock = FacebookSignInMock();

    UserRepository userRepository = UserRepository(
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

    test('Signing in with Google returns a Firebase user', () async {
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

  });
}