import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/login/login_state.dart';

//import '../user_tests/user_repository_mocks.dart';
import 'authentication_firebase_mock.dart';
import 'authentication_mock.dart';

void main() {

  AuthenticationBloc _authenticationBloc;
  LoginBlocMock _loginBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  //UserRepositoryMock _userRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    //_userRepositoryMock = UserRepositoryMock();
    _loginBloc = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
    _authenticationBloc = AuthenticationBloc(
        authenticationRepository: _authenticationRepositoryMock,
        loginBloc: _loginBloc
      );
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
      _authenticationBloc.add(AppStarted());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when logged in', () {
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Authenticated()
      ];

      when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(true));
      when(_authenticationRepositoryMock.getUser())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
        
      //Act
      _authenticationBloc.add(AppStarted());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(AppStarted());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when sign up with credentials', (){
      //Arrange
      final randomValidEmail = "test@email.com";
      final randomValidPassword = "password123";
      final expectedStates = [
        Uninitialized(),
        Authenticated()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(randomValidEmail, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.add(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(
        InitializedCredentialsSignUp(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test('emits Uninitialized -> Authenticated when LoginSucceeded state is emited', (){

      //Arrange
      final loginEmittedStates = [
        LoginInitial(),
        LoginSucceeded()
      ];

      final authenticatedExpectedState = [
        Uninitialized(),
        Authenticated()
      ];

      whenListen(_loginBloc, Stream.fromIterable(loginEmittedStates));

      //Act
      _authenticationBloc = AuthenticationBloc(
        loginBloc: _loginBloc, authenticationRepository: _authenticationRepositoryMock);

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(authenticatedExpectedState));
    });

    test('emits Uninitialized -> Unauthenticated when LogoutSucceeded state is emited', (){

      //Arrange
      final loginEmittedStates = [
        LoginInitial(),
        LogoutSucceeded()
      ];

      final authenticatedExpectedState = [
        Uninitialized(),
        Unauthenticated()
      ];

      whenListen(_loginBloc, Stream.fromIterable(loginEmittedStates));

      //Act
      _authenticationBloc = AuthenticationBloc(
        loginBloc: _loginBloc, authenticationRepository: _authenticationRepositoryMock);

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(authenticatedExpectedState));
    });
  });
}