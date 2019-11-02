import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_event.dart';
import 'package:reazzon/src/login/login_state.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';

void main() {
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();
  final randomValidPassword = "password";
  
  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _authenticationBloc = AuthenticationBloc(_authenticationRepositoryMock);
    _loginBloc = LoginBloc(
      authenticationRepository: _authenticationRepositoryMock, 
      authenticationBloc: _authenticationBloc
    );
  });

  group('Login initiated', () {
    test('maps to Authenticated state when LoginButtonPressed returns user', () {
      //Arrange
      final expectedAuthState = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      final expectedLoginState = [
        LoginInitial(),
        LoginLoading()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(LoginButtonPressed());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedAuthState));
      expectLater(_loginBloc.state, emitsInOrder(expectedLoginState));
    });

    test('maps to Unauthenticated state when LoginButtonPressed returns no user', () {
      //Arrange
      final expectedAuthState = [
        Uninitialized()
      ];

      final expectedLoginState = [
        LoginInitial(),
        LoginFailure(error: "Could not find user. Please try different credentials")
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(null));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(LoginButtonPressed());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedAuthState));
      expectLater(_loginBloc.state, emitsInOrder(expectedLoginState));
    });

    test('maps to Unauthenticated state when LoginButtonPressed throws exception', () {
      //Arrange
      final expectedAuthState = [
        Uninitialized()
      ];

      final expectedLoginState = [
        LoginInitial(),
        LoginFailure(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenThrow(HttpException('unavailable'));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(LoginButtonPressed());

      //Assert
      expectLater(_authenticationBloc.state, emitsInOrder(expectedAuthState));
      expectLater(_loginBloc.state, emitsInOrder(expectedLoginState));
    });
  });
}