import 'dart:async';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/services/IAuthentication.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc with Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();

  IAuthentication _authService;

  SignUpBloc(IAuthentication authService) {
    _authService = authService;
  }

  // Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPassword.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest3(email, password, confirmPassword, (e, p, cp) {
    if(p != cp){
      _confirmPassword.addError("Passwords do not match");
    }
    return true;
  });
  
  // Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  submit() async {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print(validEmail);
    print(validPassword);

    await _authService.signUp(validEmail, validPassword);
  }

  void dispose() {
    _email.close();
    _password.close();
    _confirmPassword.close();
  }
}