import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository {}
class AuthenticationBlocMock extends Mock implements AuthenticationBloc {
  AuthenticationRepositoryMock authenticationRepository;
  
  AuthenticationBlocMock({this.authenticationRepository});

  Future<bool> isSignedIn() async => await authenticationRepository.isSignedIn();
  Future<FirebaseUser> getUser() async => await authenticationRepository.getUser(); 
}

class LoginBlocMock extends Mock implements LoginBloc {
  AuthenticationRepositoryMock authenticationRepository;

  LoginBlocMock({this.authenticationRepository});
}

class SignUpBlocMock extends Mock implements SignupBloc {
  AuthenticationRepositoryMock authenticationRepository;

  SignUpBlocMock({this.authenticationRepository});
}