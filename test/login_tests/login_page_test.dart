import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/login_page.dart';
import 'package:bloc_test/bloc_test.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  LoginBlocMock _loginBloc;
  final fireBaseUserMock = FirebaseUserMock();
  final randomValidPassword = "password";
  final buttonFinder = find.byKey(Key('credentials_button'));
  final snackBarFinder = find.byKey(Key("snack_bar_failure"));
  final emailFieldFinder = find.byKey(Key('email_field'));
  final passwordFieldFinder = find.byKey(Key('password_field'));
  
  Widget makeTestableWidget() {
    return BlocProvider<LoginBloc>(
      builder: (context) => _loginBloc,
      child: MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        )
      ),
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _loginBloc = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Show snack bar when state is LoginFailure', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginFailure(error: "Could not find user. Please try different credentials")
    ];
    
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());

    expect(snackBarFinder, findsNothing);

    await tester.enterText(emailFieldFinder, fireBaseUserMock.email);
    await tester.pumpAndSettle();

    await tester.enterText(passwordFieldFinder, randomValidPassword);
    await tester.pumpAndSettle();
    
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    //Assert
    expect(snackBarFinder, findsOneWidget);
  });
}
