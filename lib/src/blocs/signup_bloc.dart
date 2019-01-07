import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/firebase_authentication.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc with Validators implements BlocBase {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();

  PublishSubject<List<String>> _selectedReazzonsController = PublishSubject<List<String>>();

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
  Stream<String> get outLastName => _lastNameController.stream;
  Stream<String> get outUserName => _userNameController.stream;

  Stream<bool> get submitValid => Observable.combineLatest3(
    outEmail, outPassword, outConfirmPassword, (e, p, cp) => true );
  Stream<bool> get updateDetailsValid => Observable.combineLatest3(
    outFirstName, outLastName, outUserName, (f, l, u) => true );
  
  // Change data
  Function(String) get inEmail => _emailController.sink.add;
  Function(String) get inPassword => _passwordController.sink.add;
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Function(String) get inFirstName => _firstNameController.sink.add;
  Function(String) get inLastName => _lastNameController.sink.add;
  Function(String) get inUserName => _userNameController.sink.add;


  Future<FirebaseUser> submit() async {
    return await firebaseAuthentication.signUp(
      _emailController.value, 
      _passwordController.value
    );
  }

  Future<void> submitDetails(User user) async {
    await user.updateDetails(
      _firstNameController.value, 
      _lastNameController.value, 
      _userNameController.value
    ); 
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _firstNameController.close();
    _lastNameController.close();
    _userNameController.close();
    _selectedReazzonsController.close();
  }
}