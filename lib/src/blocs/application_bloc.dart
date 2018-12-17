import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  User reazzonUser;

  BehaviorSubject<FirebaseUser> _currentUserController = BehaviorSubject<FirebaseUser>();
  Sink<FirebaseUser> get inCurrentUser => _currentUserController.sink;
  Stream<FirebaseUser> get outCurrentUser => _currentUserController.stream;

  ApplicationBloc(){
    _currentUserController.listen(_setCurrentUser);
  }

  void _setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());

    reazzonUser = new User(authenticatedUser);
  }

  @override
  void dispose() {
    _currentUserController.close();
  }
}