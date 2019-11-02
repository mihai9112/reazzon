import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/login_page.dart';

import '../authentication_tests/authentication_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  AuthenticationBlocMock _authenticationBloc;
  LoginBloc _loginBloc;
  
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
    _authenticationBloc = AuthenticationBlocMock(authenticationRepository: _authenticationRepositoryMock);
    _loginBloc = LoginBloc(authenticationRepository: _authenticationRepositoryMock, authenticationBloc: _authenticationBloc);
  });

  testWidgets('Show snack bar when state is LoginFailure', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginFailure(error: "Could not find user. Please try different credentials")
    ];

    when(_authenticationRepositoryMock.signInWithCredentials("est@est.com", "password"))
      .thenAnswer((_) => Future.value(null));

    final button = find.byKey(Key('credentials_button'));
    
    //Act
    await tester.pumpWidget(makeTestableWidget());

    Finder finder = find.byKey(Key("snack_bar"));
    expect(finder, findsNothing);

    await tester.enterText(find.byKey(Key('email_field')), 'est@est.com');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('password_field')), 'password');
    await tester.pumpAndSettle();
    
    await tester.tap(button);
    await tester.pumpAndSettle();

    //Assert
    expectLater(_loginBloc.state, emitsInOrder(expectedStates)).then((_) {
      expect(finder, findsOneWidget);
    });
  });
}
