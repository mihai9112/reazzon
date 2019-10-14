import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';

import 'authentication_mock.dart';

void main() {

  AuthenticationBloc _authenticationBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _authenticationBloc = AuthenticationBloc(authenticationRepository: _authenticationRepositoryMock);
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
  });
}