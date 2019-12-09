import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';
import 'package:reazzon/src/signup/presentation/pages/signup_continue_page.dart';

import '../authentication_tests/authentication_mock.dart';
import '../helpers/navigator_observer_mock.dart';

void main() async {
  
  SignUpBlocMock _signUpBlocMock;
  final mockNavigatorObserver = MockNavigatorObserver();
  
  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(
          builder: (context) => _signUpBlocMock,
        )
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SignupContinuePage(),
        ),
        navigatorObservers: [mockNavigatorObserver]
      )
    );
  }

  setUp(() {
    _signUpBlocMock = SignUpBlocMock();
  });


}