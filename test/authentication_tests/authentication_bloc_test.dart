import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';

import 'authentication_mock.dart';

void main() {

  AuthenticationBloc _authenticationBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;

  final mockEmail = "test@test.com";

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
        Authenticated(mockEmail)
      ];

      when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(true));
      when(_authenticationRepositoryMock.getUser())
        .thenAnswer((_) => Future.value(mockEmail));
        
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
  });
}