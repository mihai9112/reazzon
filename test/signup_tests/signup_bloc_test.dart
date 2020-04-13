import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/features/signup/presentation/bloc/signup.dart';
import 'package:reazzon/src/user/user.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';
import '../helpers/shared_preferences.dart';
import '../user_tests/user_repository_mocks.dart';

void main() async {
  SignupBloc _signupBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  UserRepositoryMock _userRepositoryMock;
  final fireBaseUserMock = FirebaseUserMock();
  CachedPreferencesMock cachedPreferencesMock = CachedPreferencesMock();
  SharedObjects.prefs = cachedPreferencesMock;
  final randomValidPassword = "password";

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _userRepositoryMock = UserRepositoryMock();
    _signupBloc = SignupBloc(authenticationRepository: _authenticationRepositoryMock, userRepository: _userRepositoryMock);
  });

  group('Signup initiated', () {
    test('maps to SignupSucceeded when InitializedCredentialsSignUp returns user', () async {
      
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupLoading(),
        SignupSucceeded()
      ];

      when(_authenticationRepositoryMock.signUpWithCredentials(fireBaseUserMock.email, randomValidPassword))
        .thenAnswer((_) => Future.value(fireBaseUserMock));
      when(_userRepositoryMock.saveDetailsFromProvider(fireBaseUserMock))
        .thenAnswer((_) => Future.value(UserMock()));

      //Act 
      _signupBloc.changeEmail(fireBaseUserMock.email);
      _signupBloc.changePassword(randomValidPassword);
      _signupBloc.changeConfirmPassword(randomValidPassword);

      _signupBloc.add(InitializedCredentialsSignUp());

      //Assert
      await emitsExactly(_signupBloc, expectedSignupState);
    });

    test('maps to SignupFailed when InitializedCredentialsSignUp returns no user', () async {
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupLoading(),
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
      await emitsExactly(_signupBloc, expectedSignupState);
    });

    test('maps to SignupFailed when InitializedCredentialsSignUp throws exception', () async {
      //Arrange
      final expectedSignupState = [
        InitialSignupState(),
        SignupLoading(),
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
      await emitsExactly(_signupBloc, expectedSignupState);
    });
  });

  test("maps to SignupSucceeded when CompleteSignup completes", () async {
    //Arrange
    final expectedSignupState = [
      InitialSignupState(),
      SignupLoading(),
      SignupSucceeded()
    ];

    when(_userRepositoryMock.updateDetails(argThat(isA<User>())))
        .thenAnswer((_) => Future.value(User()));
    when(SharedObjects.prefs.getString(any))
        .thenReturn("test");

    //Act
    _signupBloc.changeUsername("mockusername");
    _signupBloc.add(CompleteSignup());

    //Assert
    await emitsExactly(_signupBloc, expectedSignupState);
  });

  test("maps to SignupFailed when CompleteSignup fails", () async {
    //Arrange
    final expectedSignupState = [
      InitialSignupState(),
      SignupLoading(),
      SignupFailed()
    ];

    when(_userRepositoryMock.updateDetails(argThat(isA<User>())))
        .thenThrow(HttpException('unavailable'));
    when(SharedObjects.prefs.getString(any))
        .thenReturn("test");

    //Act
    _signupBloc.changeUsername("mockusername");
    _signupBloc.add(CompleteSignup());

    //Assert
    await emitsExactly(_signupBloc, expectedSignupState);
  });

  group('Reazzon selection', () {
    blocTest(
      'should load all reazzons',
      build: () => _signupBloc,
      act: (SignupBloc bloc) async => bloc.add(LoadReazzons()),
      expect: [
        isA<InitialSignupState>(),
        isA<ReazzonsLoaded>()
      ]
    );

    blocTest(
      'should select reazzon',
      build: () => _signupBloc,
      act: (SignupBloc bloc) async => bloc..add(LoadReazzons())
        ..add(SelectReazzon(Reazzon(1, '#Reazzon'))),
      expect: [
        isA<InitialSignupState>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonsLoaded>()
      ] 
    );

    blocTest(
      'should deselect reazzon',
      build: () => _signupBloc,
      act: (SignupBloc bloc) async => bloc..add(LoadReazzons())
        ..add(DeselectReazzon(Reazzon(1, '#Reazzon'))),
      expect: [
        isA<InitialSignupState>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonsLoaded>()
      ] 
    );

    blocTest(
      'should not select reazzon after 3 reazzons selected',
      build: () => _signupBloc,
      act: (SignupBloc bloc) async => bloc..add(LoadReazzons())
        ..add(SelectReazzon(Reazzon(1, '#Reazzon')))
        ..add(SelectReazzon(Reazzon(2, '#Reazzon')))
        ..add(SelectReazzon(Reazzon(3, '#Reazzon')))
        ..add(SelectReazzon(Reazzon(4, '#Reazzon'))),
      expect: [
        isA<InitialSignupState>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonsLoaded>(),
        isA<ReazzonLimitSelected>(),
        isA<ReazzonsLoaded>()
      ] 
    );
  });
}