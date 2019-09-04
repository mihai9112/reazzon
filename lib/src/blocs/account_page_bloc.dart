import 'dart:async';

import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';

class AccountPageBloc extends BLOCBase {
  String loggedUserId;

  AccountPageBloc({this.loggedUserId});

  @override
  initialState() => null;

  @override
  Stream mapEventToState(event) => null;
}
