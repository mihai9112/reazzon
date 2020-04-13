import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/user/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';
import 'login_state.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with Validators {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get email => 
      _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get forgottenPasswordValid =>
      Observable.combineLatest([email], (e) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc({
    @required this.authenticationRepository,
    @required this.userRepository
  })  : assert(authenticationRepository != null),
        assert(userRepository != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is InitializedCredentialsSignIn) {
      yield* _mapInitializedCredentialsSignIn();
    }

    if(event is InitializedGoogleSignIn){
      yield* _mapGoogleSigningInToState();
    }

    if(event is InitializedFacebookSignIn){
      yield* _mapFacebookSigningInToState();
    }

    if(event is InitializedLogOut){
      yield* _mapInitializedLogOut();
    }

    if(event is InitializedForgottenPassword){
      yield* _mapInitializedForgottenPassword();
    }
  }

  Stream<LoginState> _mapInitializedCredentialsSignIn() async* {
    yield LoginLoading();
    try {
      final firebaseUser = await authenticationRepository.signInWithCredentials(
        _emailController.value, _passwordController.value);
      
      if(firebaseUser != null){
        if(!await userRepository.isProfileComplete()){
          await userRepository.saveDetailsFromProvider(firebaseUser);
          yield ProfileToBeUpdated();  
        }
        yield LoginSucceeded();
      }
      else {
        yield LoginFailed(error: "Could not find user. Please try different credentials");
      }
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield LoginFailed(error: "Error trying to login. Please try again later");
    }
    yield LoginInitial();
  }

  Stream<LoginState> _mapGoogleSigningInToState() async* {
    yield LoginLoading();
    try {
      final firebaseUser = await authenticationRepository.signInWithGoogle();
      if(firebaseUser != null){

        if(!await userRepository.isProfileComplete()){
          await userRepository.saveDetailsFromProvider(firebaseUser);
          yield ProfileToBeUpdated();  
        }
        yield LoginSucceeded();
      }
      else {
        yield LoginFailed();
      }
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield LoginFailed();
    }
  }

  Stream<LoginState> _mapFacebookSigningInToState() async* {
    yield LoginLoading();
    try {
      final firebaseUser = await authenticationRepository.signInWithFacebook();
      if(firebaseUser != null){

        if(!await userRepository.isProfileComplete()){
          await userRepository.saveDetailsFromProvider(firebaseUser);
          yield ProfileToBeUpdated();  
        }
        yield LoginSucceeded();
      }
      else {
        yield LoginFailed();
      }
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield LoginFailed();
    }
  }

  Stream<LoginState> _mapInitializedLogOut() async* {
    try {
      await authenticationRepository.signOut();
      yield LogoutSucceeded();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
    }
  }

  Stream<LoginState> _mapInitializedForgottenPassword() async* {
    try {
      await authenticationRepository.forgottenPassword(
        _emailController.value
      );
      yield ForgotPasswordSucceeded();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield ForgotPasswordFailed();
    }
  }

  void dispose(){
    _emailController.close();
    _passwordController.close();
  }
}