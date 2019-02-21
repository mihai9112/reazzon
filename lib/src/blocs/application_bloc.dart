import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';

class ApplicationBloc implements BlocBase {
  User _currentUser;
  User get currentUser => _currentUser;

  void setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());
    
    _currentUser = new User(authenticatedUser);
  }

  void updateUser(User user){
    _currentUser = user;
  }

  @override
  void dispose() {
    
  }
}