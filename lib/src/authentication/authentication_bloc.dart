import 'dart:async';
import 'package:bloc/bloc.dart';

import 'authentication.dart';
import 'authentication_event.dart';
import 'authentication_repository.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(AuthenticationRepository authenticationRepository)
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authenticationRepository.isSignedIn();
      if(isSignedIn){
        yield Authenticated("test");
      }
      yield Unauthenticated();
    }
    catch(_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }
}