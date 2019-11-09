import 'dart:async';
import 'package:bloc/bloc.dart';

import 'authentication.dart';
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
    if(event is AppStarted){
      yield* _mapAppStartedToState();
    }

    if(event is LoggedIn){
      yield Authenticated(event.user);
    }

    if(event is InitializedGoogleSignIn){
      yield* _mapGoogleSigningInToState();
    }

    if(event is InitializedFacebookSignIn){
      yield* _mapFacebookSigningInToState();
    }

    if(event is InitializedCredentialsSignUp){
      yield* _mapCredentialsSigningUpToState(event.validEmail, event.validPassword);
    }

    if(event is InitializedCredentialsSignIn){
      yield* _mapCredentialsSigningInToState(event.validEmail, event.validPassword);
    }
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

  Stream<AuthenticationState> _mapFacebookSigningInToState() async* {
    try {
      final firebaseUser = await _authenticationRepository.signInWithFacebook();
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

  Stream<AuthenticationState> _mapCredentialsSigningUpToState(String email, String password) async* {
    try {
      final firebaseUser = await _authenticationRepository.signUpWithCredentials(email, password);
      if(firebaseUser != null)
      {
        yield Authenticated(firebaseUser);
      }
      yield Unauthenticated();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapCredentialsSigningInToState(String email, String password) async* {
    try {
      final firebaseUser = await _authenticationRepository.signInWithCredentials(email, password);
      if(firebaseUser != null)
      {
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