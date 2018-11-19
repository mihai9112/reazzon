import 'package:flutter/material.dart';
import 'package:reazzon/src/login/loginBloc.dart';
import 'package:reazzon/src/login/loginProvider.dart';
import 'package:reazzon/src/signup/signUpBloc.dart';
import 'package:reazzon/src/signup/signUpProvider.dart';
import 'home/home_screen.dart';

class App extends StatelessWidget{
  final LoginBloc login;
  final SignUpBloc signup;

  App(this.login, this.signup);

  build(context) {
    return LoginProvider(
      login: login,
      child: SignUpProvider(
        signUp: signup,
        child: MaterialApp(
          title: 'Home',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen(),
          ),
        ),
      );
  }
}