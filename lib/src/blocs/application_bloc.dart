import 'dart:async';

import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  final _currentUserController = BehaviorSubject<User>();

  Function(User) get inCurrentUser => _currentUserController.sink.add;
  Stream<User> get outCurrentUser => _currentUserController.stream;

  ApplicationBloc();

  @override
  void dispose() {
    _currentUserController?.close();
  }
}