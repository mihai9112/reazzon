import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';

class ThirdSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ThirdSignUpPageState();
}

class _ThirdSignUpPageState extends State<ThirdSignUpPage> {
  SignUpBloc _signUpBloc;

  @override
  void initState()
  {
    super.initState();
    _signUpBloc = new SignUpBloc();
  }

  @override
  void dispose()
  {
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SingleChildScrollView(

      ),
    );
  }

}