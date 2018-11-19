import 'package:flutter/material.dart';
import 'package:reazzon/src/login/loginBloc.dart';
import 'package:reazzon/src/signup/signUpBloc.dart';
import 'src/app.dart';

void main() {

  final login = new LoginBloc();
  final signUp = new SignUpBloc();

  runApp(App(login, signUp));
}