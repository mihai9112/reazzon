import 'package:flutter/material.dart';
import 'package:reazzon/src/signup/signUpBloc.dart';

class SignUpProvider extends InheritedWidget {
  final signUpBloc;

  SignUpProvider({
    Key key, 
    @required SignUpBloc signUp,
    Widget child
  })
    : assert(signUp != null),
    signUpBloc = signUp, 
    super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static SignUpBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SignUpProvider) as SignUpProvider).signUpBloc;
  }
}