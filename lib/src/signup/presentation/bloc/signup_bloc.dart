import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:rxdart/rxdart.dart';
import './signup.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> with Validators {
  final AuthenticationRepository authenticationRepository;
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  List<Reazzon> _selectedReazzons = new List<Reazzon>();

  SignupBloc({
    @required this.authenticationRepository
  })
  : assert(authenticationRepository != null)
  {

  }

  Stream<String> get email =>
    _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
    _passwordController.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPasswordController.stream
      .transform(validatePassword)
      .doOnData((String c) {
    if (0 != _passwordController.value.compareTo(c)) {
      _confirmPasswordController.addError("Passwords do not match");
    }
  });
  Stream<bool> get submitValid => Observable.combineLatest3(
    email, password, confirmPassword, (e, p, cp) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmPasswordController.sink.add;
  
  @override
  SignupState get initialState => InitialSignupState();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if(event is InitializedCredentialsSignUp){
      yield* _mapCredentialsSigningUpToState();
    }

    if(event is ReazzonSelected){
      yield* _mapReazzonSelected();
    }

    if(event is ReazzonDeselected){
      yield* _mapReazzonDeselected();
    }
  }

  Stream<SignupState> _mapCredentialsSigningUpToState() async* {
    try {
      final firebaseUser = await authenticationRepository.signUpWithCredentials(
        _emailController.value,
        _passwordController.value
      );
      if(firebaseUser != null)
      {
        yield SignupSucceeded();
      }
      yield SignupFailed();
    } 
    catch (_, stacktrace) {
      //TODO: log stacktrace;
      yield SignupFailed();
    }
  }

  Stream<SignupState> _mapReazzonSelected() async* {
    
  }

  Stream<SignupState> _mapReazzonDeselected() async* {
    
  }

  void dispose(){
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
}
