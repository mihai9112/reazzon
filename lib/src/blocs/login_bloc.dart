import 'dart:async';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators implements BlocBase {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _messagesController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<User>();

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest2(email, password, (e, p) => true);
  Stream<User> get outUser => _userController.stream;
  Stream<String> get outMessages => _messagesController.stream;
  
  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get _inMessages => _messagesController.sink.add;
  Function(User) get _inUser => _userController.sink.add;

  Future<bool> submit() async {
    var result = false;

    try {
      var user = await firebaseAuthentication.signIn(
        _emailController.value, 
        _passwordController.value
      );
      _inUser(new User(user));
      result = true;
    } 
    catch (e) {
      _inMessages(e.message);
    }

    return result;
  }

  Future<bool> registerWithGoogle() async {
    var result = false;

    await firebaseAuthentication.signInWithGoogle()
      .then((onValue){
        _inUser(new User(onValue));
        result = true;
      })
      .catchError((onError){
        _inMessages(onError.message);
      });

    return result;
  }

  Future<bool> registerWithFacebook() async {
    var result = false;

    await firebaseAuthentication.signInWithFacebook()
      .then((onValue){
        _inUser(new User(onValue));
        result = true;
      })
      .catchError((onError){
        _inMessages(onError.message);
      });

      return result;
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _messagesController.close();
    _userController.close();
  }
}