import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/user/user.dart';

import '../user_tests/user_repository_mocks.dart';
import 'authentication_firebase_mock.dart';
import 'authentication_mock.dart';

void main() {

  AuthenticationBloc _authenticationBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  UserRepositoryMock _userRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _userRepositoryMock = UserRepositoryMock();
    when(_userRepositoryMock.isProfileComplete())
      .thenAnswer((_) => Future.value(true));
    _authenticationBloc = AuthenticationBloc(
        authenticationRepository: _authenticationRepositoryMock, 
        userRepository: _userRepositoryMock
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
        Authenticated(fireBaseUserMock)
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

    test('emits Uninitialized -> Authenticated when sign in with Google', (){
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Authenticated(fireBaseUserMock)
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));

      //Act
      _authenticationBloc.add(InitializedGoogleSignIn());
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(InitializedGoogleSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(InitializedGoogleSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(InitializedFacebookSignIn());
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(InitializedFacebookSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(InitializedFacebookSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
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
      _authenticationBloc.add(
        InitializedCredentialsSignIn(
          validEmail: randomValidEmail, 
          validPassword: randomValidPassword
        )
      );

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> ProfileToBeUpdated when sign in with Google returns profile not complete", () {

      //Arrange
      final expectedStates = [
        Uninitialized(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _authenticationBloc.add(InitializedGoogleSignIn());
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> Unauthenticated when user repository throws error on Google sign in", () {
      
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenThrow(HttpException('unavailable'));
      
      //Act
      _authenticationBloc.add(InitializedGoogleSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> ProfileToBeUpdated when sign in with Facebook returns profile not complete", () {

      //Arrange
      final expectedStates = [
        Uninitialized(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _authenticationBloc.add(InitializedFacebookSignIn());
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> Unauthenticated when user repository throws error on Facebook sign in", () {
      
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithFacebook())
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenThrow(HttpException('unavailable'));
      
      //Act
      _authenticationBloc.add(InitializedFacebookSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> ProfileToBeUpdated when sign in with credentials returns profile not complete", () {

      //Arrange
      final expectedStates = [
        Uninitialized(),
        ProfileToBeUpdated()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(any, any))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenAnswer((_) => Future.value(false));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(User()));

      //Act
      _authenticationBloc.add(InitializedCredentialsSignIn());
      
      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });

    test("emits Uninitialized -> Unauthenticated when user repository throws error on credentials sign in", () {
      
      //Arrange
      final expectedStates = [
        Uninitialized(),
        Unauthenticated()
      ];

      when(_authenticationRepositoryMock.signInWithCredentials(any, any))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.isProfileComplete())
        .thenThrow(HttpException('unavailable'));
      
      //Act
      _authenticationBloc.add(InitializedCredentialsSignIn());

      //Assert
      expectLater(_authenticationBloc, emitsInOrder(expectedStates));
    });
    
  });
}