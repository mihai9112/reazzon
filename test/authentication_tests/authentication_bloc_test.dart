import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';

import 'authentication_firebase_mock.dart';
import 'authentication_mock.dart';

void main() {

  AuthenticationBloc _authenticationBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _authenticationBloc = AuthenticationBloc(_authenticationRepositoryMock);
  });

  group('AppStarted', () {
    test('emits Uninitialized -> Unauthenticated when not logged in', () {
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(false));
        
      //Act
      _authenticationBloc.dispatch(AppStarted());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when logged in', () {
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(true));
      when(_authenticationRepositoryMock.getUser())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
        
      //Act
      _authenticationBloc.dispatch(AppStarted());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when error throws', () {
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.isSignedIn())
        .thenThrow(HttpException('unavailable'));

      //Act
      _authenticationBloc.dispatch(AppStarted());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when sign in with Google', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.dispatch(InitializedGoogleSignIn());
      
      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with Google throws error', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenThrow(HttpException('unavailable'));

      //Act
      _authenticationBloc.dispatch(InitializedGoogleSignIn());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with Google return null user', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => null);

      //Act
      _authenticationBloc.dispatch(InitializedGoogleSignIn());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when sign in with Facebook', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.dispatch(InitializedFacebookSignIn());
      
      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with Facebook throws error', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenThrow(HttpException('unavailable'));

      //Act
      _authenticationBloc.dispatch(InitializedFacebookSignIn());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with Facebook return null user', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => null);

      //Act
      _authenticationBloc.dispatch(InitializedFacebookSignIn());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when sign up with credentials', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(randomValidEmail, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );
      
      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign up with credentials throws error', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(randomValidEmail, randomValidPassword))
        .thenThrow(HttpException('unavailable'));

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign up with credentials return null user', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(randomValidEmail, randomValidPassword))
        .thenAnswer((_) => null);

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when sign in with credentials', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(randomValidEmail, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );
      
      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with credentials throws error', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(randomValidEmail, randomValidPassword))
        .thenThrow(HttpException('unavailable'));

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Unauthenticated when sign in with credentials return null user', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(randomValidEmail, randomValidPassword))
        .thenAnswer((_) => null);

      //Act
      _authenticationBloc.dispatch(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedStates));
    });
    
  });
}