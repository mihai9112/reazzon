import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_event.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/login_page.dart';

import '../authentication_tests/authentication_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  AuthenticationBloc _authenticationBloc;
  LoginBlocMock _loginBlocMock;
  
  Widget makeTestableWidget() {
    return BlocProvider<LoginBloc>(
      builder: (context) => _loginBlocMock,
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _authenticationBloc = AuthenticationBloc(_authenticationRepositoryMock);
    _loginBlocMock = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Show snack bar when state is LoginFailure', (WidgetTester tester) async {

    //Arrange
    when(_loginBlocMock.currentState)
        .thenAnswer((_) => LoginFailure(error: "Error"));
    
    //Act
    await tester.pumpWidget(makeTestableWidget());

    //Assert
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
