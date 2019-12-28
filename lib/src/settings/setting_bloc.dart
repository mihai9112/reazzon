import 'dart:async';
import 'dart:io';

import 'package:reazzon/src/domain/validators.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/settings/setting_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class SettingUserModel {
  String email;
  String userName;
  String firstName;
  String lastName;
  List<String> reazzons;
  String imageURL;

  SettingUserModel.fromDoc(doc, e) {
    List list = doc['reazzons'] ?? [];
    List<String> _list = [];
    list.forEach((item) {
      _list.add(item.toString());
    });

    this.email = e;
    this.userName = doc['userName'] ?? '';
    this.firstName = doc['firstName'] ?? '';
    this.lastName = doc['lastName'] ?? '';
    this.imageURL = doc['imageURL'] ??
        'https://rukminim1.flixcart.com/image/352/352/poster/m/j/f/cute-new-born-baby-non-tearable-synthetic-sheet-poster-pb008-original-imae7qvrnsygcwg6.jpeg';
    this.reazzons = _list;
  }
}

class SettingsBloc extends Bloc with Validators {
  SettingRepository settingRepository;

  // -- user --
  Stream<SettingUserModel> get currentUser {
    return (settingRepository as FireBaseSettingRepository).getUserDetails();
  }

  // -- first name --
  final _firstNameController = BehaviorSubject<String>();
  Stream<String> get outFirstName =>
      _firstNameController.stream;
  Function(String) get inFirstName => _firstNameController.sink.add;

  // -- last name --
  final _lastNameController = BehaviorSubject<String>();
  Stream<String> get outLastName =>
      _lastNameController.stream;
  Function(String) get inLastName => _lastNameController.sink.add;

  // -- user name --
  final _userNameController = BehaviorSubject<String>();
  Stream<String> get outUserName =>
      _userNameController.stream;
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
        outPassword,
        outConfirmPassword,
        (e, p) => true,
      );

  // -- reazzons --
  final _reazzonMessageController = BehaviorSubject<String>();
  final _availableReazzonsController = BehaviorSubject<List<Reazzon>>();

  bool canAddReazzon = true;

  Stream<List<Reazzon>> get outAvailableReazzons =>
      _availableReazzonsController.stream;

  Stream<String> get outReazzonMessage => _reazzonMessageController.stream;

  Function(String) get _inReazzonMessage => _reazzonMessageController.sink.add;

  Function(List<Reazzon>) get inAvailableReazzon =>
      _availableReazzonsController.sink.add;

  SettingsBloc(this.settingRepository) {
    //_availableReazzonsController.add(Reazzon.allReazzons());

    _availableReazzonsController.stream.listen((onData) {
      if (onData.where((reazzon) => reazzon.isSelected == true).length >= 3) {
        _inReazzonMessage("No more then 3 reazzon to be selected");
        canAddReazzon = false;
      } else {
        _inReazzonMessage("Select at least 1 reazzon");
        canAddReazzon = true;
      }
    });
  }

  initializeReazzon(List<Reazzon> reazzons) {
    List<Reazzon> _list = null; //Reazzon.allReazzons();

    reazzons.forEach((reazzon) {
      for (int i = 0; i < _list.length; i++) {
        if (reazzon.value.compareTo(_list[i].value) == 0) {
          //_list[i].setSelection();
        }
      }
    });

    inAvailableReazzon(_list);
  }

  @override
  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _userNameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _availableReazzonsController.close();
    _reazzonMessageController.close();
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

  Future<bool> changeReazzons() async {
    List<Reazzon> reazzons = await outAvailableReazzons.first;
    Set<Reazzon> selected = Set<Reazzon>();

    reazzons.forEach((r) {
      if (r.isSelected) selected.add(r);
    });

    return await settingRepository
        .changeReazzons(selected.map((r) => r.value).toList());
  }

  void removeToken() async {
    settingRepository.removePushToken();
  }

  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    return null;
  }
}
