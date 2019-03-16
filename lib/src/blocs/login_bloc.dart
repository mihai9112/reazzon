import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/services/firebase_authentication.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators implements BlocBase {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _messages = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest2(email, password, (e, p) => true);
  
  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get _inMessages => _messages.sink.add;

  Future<FirebaseUser> submit() async {
    return await firebaseAuthentication.signIn(
        _emailController.value, 
        _passwordController.value
      )
      .catchError((onError){
        _inMessages(onError.message);
      });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _messages.close();
  }
}