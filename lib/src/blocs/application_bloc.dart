import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  User reazzonUser;

  BehaviorSubject<List<String>> _availableReazzonsController = BehaviorSubject<List<String>>();
  BehaviorSubject<FirebaseUser> _currentUserController = BehaviorSubject<FirebaseUser>();
  Sink<FirebaseUser> get inCurrentUser => _currentUserController.sink;
  Stream<FirebaseUser> get outCurrentUser => _currentUserController.stream;
  Stream<List<String>> get outAvailableReazzons => _availableReazzonsController;

  ApplicationBloc(){
    _loadReazzons();
    _currentUserController.listen(_setCurrentUser);
  }

  void _setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());

    
    reazzonUser = new User(authenticatedUser);
  }

  void _loadReazzons()
  {
    _availableReazzonsController.sink.add(List<String>.generate(20, (int index){
      return index.toString();
    }));
  }

  @override
  void dispose() {
    _currentUserController.close();
    _availableReazzonsController?.close();
  }
}