import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_bloc.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';
import 'login_state.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with Validators {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get email => 
      _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc({
    @required this.authenticationRepository,
    @required this.authenticationBloc,
  })  : assert(authenticationRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginButtonPressed) {
      yield* _mapLoginButtonPressedToState();
    }
  }

  Stream<LoginState> _mapLoginButtonPressedToState() async* {
    try {
      final loggedInUser = await authenticationRepository.signInWithCredentials(
        _emailController.value, _passwordController.value);
      
      if(loggedInUser != null){
        authenticationBloc.dispatch(LoggedIn(loggedInUser));
        yield LoginLoading();
      }
      else {
        yield LoginFailure(error: "Could not find user. Please try different credentials");
      }
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield LoginFailure(error: "Error trying to login. Please try again later");
    }
    // yield LoginInitial();
  }

  @override
  void dispose(){
    _emailController.close();
    _passwordController.close();
    super.dispose();
  }
}