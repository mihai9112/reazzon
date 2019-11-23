import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/forgotten_password_page.dart';

import '../authentication_tests/authentication_mock.dart';

void main() async {
  LoginBlocMock _loginBloc;
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  final snackBarFailureFinder = find.byKey(Key("snack_bar_forgot_password_failure"));
  final snackBarSuccessfulFinder = find.byKey(Key("snack_bar_forgot_password_succeeded"));
  
  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          builder: (context) => _loginBloc
        )
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ForgottenPasswordPage(),
        )
      )
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _loginBloc = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Show snack bar when state is ForgotPasswordSucceeded', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      ForgotPasswordSucceeded()
    ];
    
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarSuccessfulFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarSuccessfulFinder, findsOneWidget);
  });

  testWidgets('Show snack bar when state is ForgotPasswordFailed', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      ForgotPasswordFailed()
    ];
    
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarFailureFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarFailureFinder, findsOneWidget);
  });
}