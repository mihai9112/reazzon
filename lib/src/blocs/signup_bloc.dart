import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/reazzon.dart';
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
  final _reazzonMessageController = BehaviorSubject<String>();
  final _availableReazzonsController = BehaviorSubject<List<Reazzon>>();

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
  Stream<String> get outReazzonMessage => _reazzonMessageController.stream;
  Stream<List<Reazzon>> get outAvailableReazzons => _availableReazzonsController.stream;
  
  
  // Change data
  Function(String) get inEmail => _emailController.sink.add;
  Function(String) get inPassword => _passwordController.sink.add;
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Function(String) get inFirstName => _firstNameController.sink.add;
  Function(String) get inLastName => _lastNameController.sink.add;
  Function(String) get inUserName => _userNameController.sink.add;

  Function(String) get inReazzonMessage => _reazzonMessageController.sink.add;
  Sink<List<Reazzon>> get _inAvailableReazzons => _availableReazzonsController.sink;

  Future<FirebaseUser> submit() async {
    return await firebaseAuthentication.signUp(
      _emailController.value, 
      _passwordController.value
    );
  }

  Future<User> updateDetails(User user) async {
    await user.updateDetails(
      _firstNameController.value, 
      _lastNameController.value, 
      _userNameController.value
    ); 
    return user;
  }

  void loadReazzons()
  {
    var availableReazzons = new List<Reazzon>();
    availableReazzons.addAll([
      new Reazzon("#Divorce"), new Reazzon("#Perfectionist"),
      new Reazzon("#Breakups"), new Reazzon("#Loneliness"),
      new Reazzon("#Grief"), new Reazzon("#WorkStress"),
      new Reazzon("#FinancialStress"), new Reazzon("#KidsCustody"),
      new Reazzon("#Bullying"), new Reazzon("#Insomnia"),
      new Reazzon("#MoodSwings"), new Reazzon("#Preasure\nToSucceed"),
      new Reazzon("#Anxiety"), new Reazzon("#Breakups"),
      new Reazzon("#Cheating"), new Reazzon("#SelfEsteem"),
      new Reazzon("#BodyImage"), new Reazzon("#Exercise\nMotivation")
    ]);
    _inAvailableReazzons.add(availableReazzons);
  }

  void updateReazzons(List<Reazzon> reazzons){
    _inAvailableReazzons.add(reazzons);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _firstNameController.close();
    _lastNameController.close();
    _userNameController.close();
    _reazzonMessageController.close();
    _availableReazzonsController?.close();
  }
}