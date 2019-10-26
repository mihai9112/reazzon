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

    if(event is InitializedGoogleSignIn){
      yield* _mapGoogleSigningInToState();
    }
    yield Uninitialized();
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authenticationRepository.isSignedIn();
      if(isSignedIn){
        yield Authenticated(await _authenticationRepository.getUser());
      }
      yield Unauthenticated();
    }
    catch(_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapGoogleSigningInToState() async* {
    try {
      final firebaseUser = await _authenticationRepository.signInWithGoogle();
      if(firebaseUser != null){
        yield Authenticated(firebaseUser);
      }
      yield Unauthenticated();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }
}