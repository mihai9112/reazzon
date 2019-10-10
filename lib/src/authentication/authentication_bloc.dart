import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reazzon/src/repositories/authentication_repository.dart';

import 'authentication.dart';
import 'authentication_event.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStarted) {
      yield* mapAppStartedToState();
    }
  }

  Stream<AuthenticationState> mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authenticationRepository.isSignedIn();
      if(isSignedIn){
        yield Authenticated("test");
      }
      yield Unauthenticated();
    }
    catch(_, stacktrace) {
      print(stacktrace);
    }
  }
}