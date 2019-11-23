import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_state.dart';

import 'authentication.dart';
import 'authentication_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final LoginBloc loginBloc;
  StreamSubscription loginBlocSubscription;

  AuthenticationBloc({
    @required this.authenticationRepository,
    @required this.loginBloc
  })
  : assert(authenticationRepository != null),
    assert(loginBloc != null)
  {
    loginBlocSubscription = loginBloc.listen((state){
      if(state is LoginSucceeded){
        add(LoggedIn());
      }

      if(state is LogoutSucceeded){
        add(LoggedOut());
      }
    });
  }
    
  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStarted){
      yield* _mapAppStartedToState();
    }

    if(event is LoggedIn){
      yield Authenticated();
    }

    if(event is LoggedOut){
      yield Unauthenticated();
    }

    if(event is InitializedCredentialsSignUp){
      yield* _mapCredentialsSigningUpToState(event.validEmail, event.validPassword);
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await authenticationRepository.isSignedIn();
      if(isSignedIn){
        yield Authenticated();
      }
      yield Unauthenticated();
    }
    catch(_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapCredentialsSigningUpToState(String email, String password) async* {
    try {
      final firebaseUser = await authenticationRepository.signUpWithCredentials(email, password);
      if(firebaseUser != null)
      {
        yield Authenticated();
      }
      yield Unauthenticated();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield Unauthenticated();
    }
  }

  @override
  Future<void> close() {
    loginBlocSubscription.cancel();
    return super.close();
  }
}