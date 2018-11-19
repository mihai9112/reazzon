import 'package:flutter/material.dart';
import 'package:reazzon/src/login/loginBloc.dart';

class LoginProvider extends InheritedWidget {
  final loginBloc;

  LoginProvider({
    Key key,
    @required LoginBloc login, 
    Widget child
  })
  : assert(login != null),
    loginBloc = login, 
    super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginProvider) as LoginProvider).loginBloc;
  }
}