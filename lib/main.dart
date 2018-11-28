import 'package:flutter/material.dart';
import 'package:reazzon/src/login/loginBloc.dart';
import 'package:reazzon/src/services/Authentication.dart';
import 'package:reazzon/src/services/IAuthentication.dart';
import 'package:reazzon/src/signup/signUpBloc.dart';
import 'src/app.dart';

void main() {

  final IAuthentication authService = new Authentication();
  final login = new LoginBloc(authService);
  final signUp = new SignUpBloc(authService);

  runApp(App(login, signUp));
}