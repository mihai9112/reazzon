import 'dart:async';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators implements BlocBase {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

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

    //await _authService.signIn(validEmail, validPassword);
  }

  @override
  void dispose() {
    _email.close();
    _password.close();
  }
}