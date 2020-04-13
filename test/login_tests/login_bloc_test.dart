import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_event.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/user/user.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';
import '../user_tests/user_repository_mocks.dart';

void main() {
  LoginBloc _loginBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  UserRepositoryMock _userRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();
  final randomValidPassword = "password";
  
  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _userRepositoryMock = UserRepositoryMock();
    _userRepositoryMock = UserRepositoryMock();
    when(_userRepositoryMock.isProfileComplete())
      .thenAnswer((_) => Future.value(true));
    _loginBloc = LoginBloc(
      authenticationRepository: _authenticationRepositoryMock,
      userRepository: _userRepositoryMock
    );
  });

  group('Login initiated', () {
    test('maps to LoginSucceeded state when InitializedCredentialsSignIn returns user', () {
      //Arrange
      final expectedLoginState = [
        LoginInitial(),
        LoginLoading(),
        LoginSucceeded()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(InitializedCredentialsSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedLoginState));
    });

    test('maps to LoginFailed state when InitializedCredentialsSignIn returns no user', () {
      //Arrange
      final expectedLoginState = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Could not find user. Please try different credentials")
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(null));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(InitializedCredentialsSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedLoginState));
    });

    test('maps to LoginFailed state when InitializedCredentialsSignIn throws exception', () {
      //Arrange
      final expectedLoginState = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenThrow(HttpException('unavailable'));
      
      _loginBloc.changeEmail(fireBaseUserMock.email);
      _loginBloc.changePassword(randomValidPassword);

      //Act
      _loginBloc.add(InitializedCredentialsSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedLoginState));
    });

    test('emits LoginSucceeded when sign in with Google', (){
      //Arrange
      final expectedLoginState = [
        LoginInitial(),
        LoginLoading(),
        LoginSucceeded()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _loginBloc.add(InitializedGoogleSignIn());
      
      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedLoginState));
    });

    test('emits LoginFailed when sign in with Google throws error', (){
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenThrow(HttpException('unavailable'));

      //Act
      _loginBloc.add(InitializedGoogleSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test('emits LoginFailed when sign in with Google return null user', (){
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => null);

      //Act
      _loginBloc.add(InitializedGoogleSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test('emits LoginSucceeded when sign in with Facebook', (){
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        LoginSucceeded()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _loginBloc.add(InitializedFacebookSignIn());
      
      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test('emits LoginFailed when sign in with Facebook throws error', (){
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenThrow(HttpException('unavailable'));

      //Act
      _loginBloc.add(InitializedFacebookSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test('emits LoginFailed when sign in with Facebook return null user', (){
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        LoginFailed(error: "Error trying to login. Please try again later")
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => null);

      //Act
      _loginBloc.add(InitializedFacebookSignIn());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test("emits ProfileToBeUpdated when sign in with Google returns profile not complete", () {

      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _loginBloc.add(InitializedGoogleSignIn());
      
      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test("emits ProfileToBeUpdated when sign in with Facebook returns profile not complete", () {

      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _loginBloc.add(InitializedFacebookSignIn());
      
      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test("emits ProfileToBeUpdated when sign in with credentials returns profile not complete", () {

      //Arrange
      final expectedStates = [
        LoginInitial(),
        LoginLoading(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(any, any))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _loginBloc.add(InitializedCredentialsSignIn());
      
      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });

    test('emits LogoutSucceeded when logging out', (){
      
      //Arrange
      final expectedStates = [
        LoginInitial(),
        LogoutSucceeded(),
      ];

      //Act
      _loginBloc.add(InitializedLogOut());

      //Assert
      expectLater(_loginBloc, emitsInOrder(expectedStates));
    });
  });
}