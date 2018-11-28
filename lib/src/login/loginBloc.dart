import 'dart:async';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/services/IAuthentication.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  IAuthentication _authService;

  LoginBloc(IAuthentication authService) {
    _authService = authService;
  }

  // Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest2(email, password, (e, p) => true);
  
  // Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  submit() async {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print(validEmail);
    print(validPassword);

    await _authService.signIn(validEmail, validPassword);
  }

  void dispose() {
    _email.close();
    _password.close();
  }
}