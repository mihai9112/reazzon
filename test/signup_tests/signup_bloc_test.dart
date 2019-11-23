import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';

void main() async {
  SignupBloc _signupBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();
  final randomValidPassword = "password";

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _signupBloc = SignupBloc(authenticationRepository: _authenticationRepositoryMock);
  });

  group('Signup initiated', () {
    test('maps to SignupSucceeded when InitializedCredentialsSignUp returns user', (){
      
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupSucceeded()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act 
      _signupBloc.changeEmail(fireBaseUserMock.email);
      _signupBloc.changePassword(randomValidPassword);
      _signupBloc.changeConfirmPassword(randomValidPassword);

      _signupBloc.add(InitializedCredentialsSignUp());

      //Assert
      expectLater(_signupBloc, emitsInOrder(expectedSignupState));
    });

    test('maps to SignupFailed when InitializedCredentialsSignUp returns no user', (){
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupFailed()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(null));

      //Act 
      _signupBloc.changeEmail(fireBaseUserMock.email);
      _signupBloc.changePassword(randomValidPassword);
      _signupBloc.changeConfirmPassword(randomValidPassword);

      _signupBloc.add(InitializedCredentialsSignUp());

      //Assert
      expectLater(_signupBloc, emitsInOrder(expectedSignupState));
    });

    test('maps to SignupFailed when InitializedCredentialsSignUp throws exception', (){
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupFailed()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenThrow(HttpException('unavailable'));

      //Act 
      _signupBloc.changeEmail(fireBaseUserMock.email);
      _signupBloc.changePassword(randomValidPassword);
      _signupBloc.changeConfirmPassword(randomValidPassword);

      _signupBloc.add(InitializedCredentialsSignUp());

      //Assert
      expectLater(_signupBloc, emitsInOrder(expectedSignupState));
    });
  });
}