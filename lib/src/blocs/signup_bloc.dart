import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/services/firebase_authentication.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc with Validators implements BlocBase {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _firstNameController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<String> get outConfirmPassword => _confirmPasswordController.stream.transform(validatePassword)
    .doOnData((String c){
      if (0 != _passwordController.value.compareTo(c)){
        _confirmPasswordController.addError("Passwords do not match");
      }
    });
  Stream<String> get outFirstName => _firstNameController.stream;

  Stream<bool> get submitValid => Observable.combineLatest3(
    outEmail, outPassword, outConfirmPassword, (e, p, cp) => true );
  
  // Change data
  Function(String) get inEmail => _emailController.sink.add;
  Function(String) get inPassword => _passwordController.sink.add;
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Function(String) get inFirstName => _firstNameController.sink.add;


  Future<FirebaseUser> submit() async {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    return await firebaseAuthentication.signUp(validEmail, validPassword);
  }

  Future<bool> addMoreDetails() async {
    final validFirstName = _firstNameController.value;

    var result = await firebaseAuthentication.getCurrentUser();
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = validFirstName;
    await result.updateProfile(userUpdateInfo);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _firstNameController.close();
  }
}