import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';

class ApplicationBloc implements BlocBase {
  User _currentUser;

  @override
  void dispose() {
    // TODO: implement dispose
  }

}