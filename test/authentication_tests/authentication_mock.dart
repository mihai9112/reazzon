import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/repositories/authentication_repository.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository{}
class AuthenticationBlocMock extends Mock implements AuthenticationBloc{
  AuthenticationRepositoryMock authenticationRepository;
  AuthenticationBlocMock({this.authenticationRepository});

  @override
  Future<bool> isSignedIn() async {
    return await authenticationRepository.isSignedIn();
  } 
}