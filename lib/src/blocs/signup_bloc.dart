import 'dart:async';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/authentication_repository.dart';
import 'package:reazzon/src/services/user_repository.dart';
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

  List<Reazzon> _selectedReazzons = new List<Reazzon>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outConfirmPassword => _confirmPasswordController.stream
          .transform(validatePassword)
          .doOnData((String c) {
        if (0 != _passwordController.value.compareTo(c)) {
          _confirmPasswordController.addError("Passwords do not match");
        }
      });
  Stream<String> get outFirstName =>
      _firstNameController.stream.transform(validateFirstName);
  Stream<String> get outLastName =>
      _lastNameController.stream.transform(validateLastName);
  Stream<String> get outUserName =>
      _userNameController.stream.transform(validateUserName);
  Stream<bool> get submitValid => Observable.combineLatest3(
      outEmail, outPassword, outConfirmPassword, (e, p, cp) => true);
  Stream<bool> get updateDetailsValid => Observable.combineLatest3(
      outFirstName, outLastName, outUserName, (f, l, u) => true);
  Stream<String> get outReazzonMessage => _reazzonMessageController.stream;
  Stream<List<Reazzon>> get outAvailableReazzons =>
      _availableReazzonsController.stream;
  Stream<bool> get completeRegistrationValid =>
      _validRegistrationController.stream;

  // Change data
  Function(String) get inEmail => _emailController.sink.add;
  Function(String) get inPassword => _passwordController.sink.add;
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Function(String) get inFirstName => _firstNameController.sink.add;
  Function(String) get inLastName => _lastNameController.sink.add;
  Function(String) get inUserName => _userNameController.sink.add;

  Function(String) get _inReazzonMessage => _reazzonMessageController.sink.add;
  Function(List<Reazzon>) get inAvailableReazzons =>
      _availableReazzonsController.sink.add;

  Function(String) get _inMessages => _messagesController.sink.add;
  Stream<String> get outMessages => _messagesController.stream;

  Function(User) get _inUser => _userController.sink.add;
  Stream<User> get outUser => _userController.stream;

  SignUpBloc() {
    _availableReazzonsController.stream.listen((onData) {
      if (onData.where((reazzon) => reazzon.isSelected == true).length > 3) {
        _inReazzonMessage("No more then 3 reazzon to be selected");
        _validRegistrationController.add(false);
      } else {
        _selectedReazzons.clear();
        _selectedReazzons.addAll(onData);
        _validRegistrationController.add(
            _selectedReazzons.any((reazzon) => reazzon.isSelected == true));
        _inReazzonMessage("Select at least 1 reazzon");
      }
    });
  }

  Future<bool> submit() async {
    var result = false;
    User reazzonUser;

    await authenticationRepository
        .signUp(_emailController.value, _passwordController.value)
        .then((onValue) {
      reazzonUser = new User(onValue);
      User.storeUserId(reazzonUser.userId);
      _inUser(reazzonUser);
    }).catchError((onError) {
      _inMessages(onError.message);
    });

    if (reazzonUser != null) {
      try {
        var dbResult = await userRepository.createUserDetails(reazzonUser);
        result = dbResult;
      } catch (e) {
        _inMessages(e.message);
      }
    }

    if (reazzonUser.hasCreatedUser() && !result) {
      _inMessages(
          "Unable to complete registration process at the moment. Please login to complete");
    }

    return result;
  }

  Future<bool> updateDetails(User user) async {
    var result = false;

    try {
      await user.updateDetails(_firstNameController.value,
          _lastNameController.value, _userNameController.value);
      await userRepository.updateUserDetails(user);
      _inUser(user);
      result = true;
    } catch (e) {
      _inMessages(e.message);
    }

    return result;
  }

  void loadReazzons() {
    inAvailableReazzons(Reazzon.allReazzons());
  }

  Future<bool> completeRegistration(User user) async {
    var result = false;

    try {
      for (var item
          in _selectedReazzons.where((reazzon) => reazzon.isSelected == true)) {
        user.addSelectedReazzons(item);
      }
      await userRepository.updateUserDetails(user);
      _inUser(user);
      result = true;
    } catch (e) {
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
