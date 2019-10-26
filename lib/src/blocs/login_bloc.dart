import 'dart:async';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_repository.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<AuthenticationEvent, AuthenticationState> with Validators  {
  final AuthenticationRepository _authenticationRepository;
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _messagesController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<User>();
  final _successForgottenMessagesController = BehaviorSubject<String>();

  LoginBloc(this._authenticationRepository)
    : assert(_authenticationRepository != null);

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get forgottenPasswordValid =>
      Observable.combineLatest2(email, email, (e, e1) => true);
  Stream<User> get outUser => _userController.stream;
  Stream<String> get outMessages => _messagesController.stream;
  Stream<String> get outSuccessForgottenMessages =>
      _successForgottenMessagesController.stream;

  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get _inMessages => _messagesController.sink.add;
  Function(String) get _inSuccessForgottenMessages =>
      _successForgottenMessagesController.sink.add;
  Function(User) get _inUser => _userController.sink.add;

  Future<bool> submit() async {
    var result = false;

    try {
      var user = await _authenticationRepository.signInWithCredentials(
          _emailController.value, _passwordController.value);

      User.storeUserId(user.uid);
      _inUser(new User(user));
      result = true;
    } catch (e) {
      _inMessages(e.message);
    }

    return result;
  }

  Future<bool> registerWithFacebook() async {
    var result = false;

    await _authenticationRepository.signInWithFacebook().then((user) {
      User.storeUserId(user.uid);
      _inUser(new User(user));
      result = true;
    }).catchError((onError) {
      _inMessages(onError.message);
    });

    return result;
  }

  Future<bool> forgottenPassword() async {
    var result = false;

    await _authenticationRepository
        .forgottenPassword(_emailController.value)
        .then((_) {
      _inSuccessForgottenMessages(
          "Email sent successfully to ${_emailController.value}. \n Please follow instructions contained in the reset email.");
      _inMessages(null);
      result = true;
    }).catchError((onError) {
      _inMessages(onError.message);
      _inSuccessForgottenMessages(null);
    });

    return result;
  }

  Future<void> signOut() async {
    User.deleteUserId();
    return await _authenticationRepository.signOut();
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _messagesController.close();
    _userController.close();
    _successForgottenMessagesController.close();
    super.dispose();
  }

  @override
  // TODO: implement initialState
  AuthenticationState get initialState => null;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}
