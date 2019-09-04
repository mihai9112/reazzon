import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class AppState {
  BehaviorSubject<User> _userController = BehaviorSubject<User>();

  User _user;
  User get user => _user;

  Function(User) get setUser => _userController.add;

  AppState() {
    _userController.listen((onData) {
      _user = onData;
      print("USER ADDED ON APP STATE");
    });
  }

  void dispose() {
    _userController.close();
  }
}
