import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:reazzon/src/pages/login_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:reazzon/src/pages/signup_second_page.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../authentication_tests/authentication_mock.dart';
import '../helpers/navigator_observer_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  LoginBlocMock _loginBloc;
  AuthenticationBlocMock _authenticationBloc;
  final fireBaseUserMock = FirebaseUserMock();
  final snackBarFailureFinder = find.byKey(Key("snack_bar_failure"));
  final snackBarLoadingFinder = find.byKey(Key("snack_bar_loading"));
  final mockNavigatorObserver = MockNavigatorObserver();
  
  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          builder: (context) => _authenticationBloc,
        ),
        BlocProvider<LoginBloc>(
          builder: (context) => _loginBloc
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
        navigatorObservers: [mockNavigatorObserver]
      )
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _loginBloc = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
    _authenticationBloc = AuthenticationBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Show snack bar when state is LoginFailure', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginFailure(error: "Could not find user. Please try different credentials")
    ];
    
    whenListen(_authenticationBloc, Stream<AuthenticationState>.empty());
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarFailureFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarFailureFinder, findsOneWidget);
  });

  testWidgets('Navigate to second sign up page when Authenticated', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      Authenticated(fireBaseUserMock)
    ];

    whenListen(_authenticationBloc, Stream.fromIterable(expectedStates));
    whenListen(_loginBloc, Stream<LoginState>.empty());

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    //Assert
    verify(mockNavigatorObserver.didPush(any, any));
  });

  
  testWidgets('Show snack bar when state is LoginLoading', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginLoading()
    ];
    
    whenListen(_authenticationBloc, Stream<AuthenticationState>.empty());
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarLoadingFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarLoadingFinder, findsOneWidget);
  });
}
