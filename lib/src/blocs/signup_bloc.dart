import 'dart:async';
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
  final _validRegistrationController = BehaviorSubject<bool>();
  final _messagesController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<User>();

  List<Reazzon> selectedReazzons = new List<Reazzon>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<String> get outConfirmPassword => _confirmPasswordController.stream.transform(validatePassword)
    .doOnData((String c){
      if (0 != _passwordController.value.compareTo(c)){
        _confirmPasswordController.addError("Passwords do not match");
      }
    });
  Stream<String> get outFirstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get outLastName => _lastNameController.stream.transform(validateLastName);
  Stream<String> get outUserName => _userNameController.stream.transform(validateUserName);
  Stream<bool> get submitValid => Observable.combineLatest3(
    outEmail, outPassword, outConfirmPassword, (e, p, cp) => true );
  Stream<bool> get updateDetailsValid => Observable.combineLatest3(
    outFirstName, outLastName, outUserName, (f, l, u) => true );
  Stream<String> get outReazzonMessage => _reazzonMessageController.stream;
  Stream<List<Reazzon>> get outAvailableReazzons => _availableReazzonsController.stream;
  Stream<bool> get completeRegistrationValid => _validRegistrationController.stream;
  
  // Change data
  Function(String) get inEmail => _emailController.sink.add;
  Function(String) get inPassword => _passwordController.sink.add;
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Function(String) get inFirstName => _firstNameController.sink.add;
  Function(String) get inLastName => _lastNameController.sink.add;
  Function(String) get inUserName => _userNameController.sink.add;

  Function(String) get inReazzonMessage => _reazzonMessageController.sink.add;
  Sink<List<Reazzon>> get _inAvailableReazzons => _availableReazzonsController.sink;

  Function(String) get _inMessages => _messagesController.sink.add;
  Stream<String> get outMessages => _messagesController.stream;

  Function(User) get _inUser => _userController.sink.add;
  Stream<User> get outUser => _userController.stream;

  SignUpBloc(){
    _availableReazzonsController.stream
      .map((convert) => convert.any((Reazzon reazzon) => reazzon.isSelected == true))
      .listen((onData) => _validRegistrationController.add(onData));
    
    _availableReazzonsController.stream
      .map((convert) => convert.where((Reazzon reazzon) => reazzon.isSelected == true ))
      .listen((onData) {
        selectedReazzons.clear();
        selectedReazzons.addAll(onData);
      });
  }

  Future<bool> submit() async {
    var result = false;

    try {
      var user = await firebaseAuthentication.signUp(
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

  Future<bool> updateDetails(User user) async {
    var result = false;

    try {
      await user.updateDetails(
        _firstNameController.value, 
        _lastNameController.value, 
        _userNameController.value
      );
      _inUser(user);
      result = true;
    } 
    catch (e) {
      _inMessages(e.message);
    }

    return result;
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

  Future<bool> completeRegistration(User user) async {
    var result = false;

    try {
      for (var item in selectedReazzons) {
        user.addSelectedReazzons(item);
      }
      _inUser(user);
      result = true;
    } 
    catch (e) {
      _inMessages(e.message);
    }

    return result;    
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
    _validRegistrationController.close();
    _messagesController?.close();
    _userController?.close();
  }
}