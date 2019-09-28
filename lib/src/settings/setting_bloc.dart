import 'dart:async';
import 'dart:io';

import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/settings/setting_repository.dart';
import 'package:rxdart/rxdart.dart';

//class SettingsBloc extends BlocBase with Validators {
//  final _emailController = BehaviorSubject<String>();
//  final _firstNameController = BehaviorSubject<String>();
//  final _lastNameController = BehaviorSubject<String>();
//  final _userNameController = BehaviorSubject<String>();
//  final _reazzonMessageController = BehaviorSubject<String>();
//  final _availableReazzonsController = BehaviorSubject<List<Reazzon>>();
//  final _canUpdateController = BehaviorSubject<bool>();
//
//  List<Reazzon> _selectedReazzons = new List<Reazzon>();
//
//  bool _canAddReazzon = true;
//
//  // output - data
//  Stream<String> get outEmail =>
//      _emailController.stream.transform(validateEmail);
//
//  Stream<String> get outFirstName =>
//      _firstNameController.stream.transform(validateFirstName);
//
//  Stream<String> get outLastName =>
//      _lastNameController.stream.transform(validateLastName);
//
//  Stream<String> get outUserName =>
//      _userNameController.stream.transform(validateUserName);
//
//  Stream<List<Reazzon>> get outAvailableReazzons =>
//      _availableReazzonsController.stream;
//
//  Stream<String> get outReazzonMessage => _reazzonMessageController.stream;
//
//  // check validity
//  Stream<bool> get updateDetailsValid => Observable.combineLatest4(
//      outUserName ?? false,
//      outFirstName ?? false,
//      outLastName ?? false,
//      outEmail ?? false,
//      (f, l, u, e) => true).asBroadcastStream();
//
//  // input - data
//  Function(String) get inEmail => _emailController.sink.add;
//
//  Function(String) get inFirstName => _firstNameController.sink.add;
//  Function(String) get inLastName => _lastNameController.sink.add;
//  Function(String) get inUserName => _userNameController.sink.add;
//  Function(String) get _inReazzonMessage => _reazzonMessageController.sink.add;
//  Function(List<Reazzon>) get inAvailableReazzon =>
//      _availableReazzonsController.sink.add;
//
//  // constructor
//  SettingsBloc() : super() {
//    _availableReazzonsController.add(Reazzon.allReazzons());
//    _canUpdateController.add(true);
//
//    _availableReazzonsController.stream.listen((onData) {
//      if (onData.where((reazzon) => reazzon.isSelected == true).length >= 3) {
//        _inReazzonMessage("No more then 3 reazzon to be selected");
//        _canUpdateController.add(false);
//        _canAddReazzon = false;
//      } else {
//        _selectedReazzons.clear();
//        _selectedReazzons.addAll(onData);
//        _inReazzonMessage("Select at least 1 reazzon");
//        _canAddReazzon = true;
//      }
//    });
//
//    outReazzonMessage.listen((data) {});
//  }
//
//  void selectReazzon(Reazzon reazzon) {
//    if (_canAddReazzon == true && reazzon.isSelected == false) {
//      _selectedReazzons.add(reazzon..setSelection());
//    } else if (reazzon.isSelected == true) {
//      _selectedReazzons.add(reazzon..setSelection());
//    }
//    print('Selection ${reazzon.isSelected} and $_canAddReazzon');
//  }
//
//  @override
//  void dispose() {
//    _emailController.close();
//    _firstNameController.close();
//    _lastNameController.close();
//    _userNameController.close();
//    _availableReazzonsController.close();
//    _canUpdateController.close();
//    _reazzonMessageController.close();
//  }
//}

class SettingUserModel {
  String email;
  String userName;
  String firstName;
  String lastName;
  List<String> reazzons;

  SettingUserModel.fromDoc(doc, e) {
    List list = doc['reazzons'];
    List<String> _list = [];
    list.forEach((item) {
      _list.add(item.toString());
    });

    this.email = e;
    this.userName = doc['userName'];
    this.firstName = doc['firstName'];
    this.lastName = doc['lastName'];
    this.reazzons = _list;
  }
}

class SettingsBloc extends BlocBase with Validators {
  SettingRepository settingRepository;

  SettingsBloc(this.settingRepository);

  // -- user --
  Stream<SettingUserModel> get currentUser {
    return (settingRepository as FireBaseSettingRepository).getUserDetails();
  }

  // -- first name --
  final _firstNameController = BehaviorSubject<String>();
  Stream<String> get outFirstName =>
      _firstNameController.stream.transform(validateFirstName);
  Function(String) get inFirstName => _firstNameController.sink.add;

  // -- last name --
  final _lastNameController = BehaviorSubject<String>();
  Stream<String> get outLastName =>
      _lastNameController.stream.transform(validateLastName);
  Function(String) get inLastName => _lastNameController.sink.add;

  // -- user name --
  final _userNameController = BehaviorSubject<String>();
  Stream<String> get outUserName =>
      _userNameController.stream.transform(validateUserName);
  Function(String) get inUserName => _userNameController.sink.add;

  // -- email --
  final _emailController = BehaviorSubject<String>();
  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Function(String) get inEmail => _emailController.sink.add;

  // -- password --
  final _passwordController = BehaviorSubject<String>();
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Function(String) get inPassword => _passwordController.sink.add;

  final _confirmPasswordController = BehaviorSubject<String>();
  Stream<String> get outConfirmPassword => _confirmPasswordController.stream
          .transform(validatePassword)
          .doOnData((String c) {
        if (0 != _passwordController.value.compareTo(c)) {
          _confirmPasswordController.addError("Password didn\'t match");
        }
      });
  Function(String) get inConfirmPassword => _confirmPasswordController.sink.add;

  Stream<bool> get resetPasswordValid => Observable.combineLatest2(
      outPassword, outConfirmPassword, (e, p) => true);

  @override
  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _userNameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }

  Future<bool> changeFirstName() async {
    return await settingRepository.changeFirstName(_firstNameController.value);
  }

  Future<bool> changeLastName() async {
    return await settingRepository.changeLastName(_lastNameController.value);
  }

  Future<bool> changeUserName() async {
    return await settingRepository.changeUserName(_userNameController.value);
  }

  Future<bool> changeEmail() async {
    return await settingRepository.changeEmail(_emailController.value);
  }

  Future<bool> changePassword() async {
    if (_passwordController.value == _confirmPasswordController.value)
      return await settingRepository.changePassword(_passwordController.value);
    else {
      _confirmPasswordController
          .addError(Future.error('Password didn\'t match'));
      return false;
    }
  }

  Future<String> changeProfilePicture(File file) async {
    return await settingRepository.changeProfilePicture(file);
  }
}
