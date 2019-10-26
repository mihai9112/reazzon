import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository {}
class AuthenticationBlocMock extends Mock implements AuthenticationBloc {
  AuthenticationRepositoryMock authenticationRepository;
  
  AuthenticationBlocMock({this.authenticationRepository});

  Future<bool> isSignedIn() async => await authenticationRepository.isSignedIn(); 
}

class LoginBlocMock extends Mock implements LoginBloc {
  AuthenticationRepositoryMock authenticationRepository;

  LoginBlocMock({this.authenticationRepository});
}