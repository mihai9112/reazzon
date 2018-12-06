import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/services/firebase_authentication.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc with Validators implements BlocBase {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPassword.stream.transform(validatePassword)
    .doOnData((String c){
      if (0 != _password.value.compareTo(c)){
        _confirmPassword.addError("Passwords do not match");
      }
    });

  Stream<bool> get submitValid => Observable.combineLatest3(
    email, password, confirmPassword, (e, p, cp) => true );
  
  // Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  Future<FirebaseUser> submit() async {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print(validEmail);
    print(validPassword);

    return await firebaseAuthentication.signUp(validEmail, validPassword);
  }

  @override
  void dispose() {
    _email.close();
    _password.close();
    _confirmPassword.close();
  }
}