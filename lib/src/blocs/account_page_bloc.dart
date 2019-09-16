import 'package:reazzon/src/blocs/bloc_provider.dart';

class AccountPageBloc extends BlocBase {
  String loggedUserId;

  AccountPageBloc({this.loggedUserId});

  @override
  void dispose() {}
}
