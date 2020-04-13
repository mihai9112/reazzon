import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/login/login_page.dart';
import 'package:reazzon/src/login/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:reazzon/src/features/signup/presentation/bloc/signup.dart';

import '../authentication_tests/authentication_mock.dart';
import '../helpers/navigator_observer_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  LoginBlocMock _loginBloc;
  SignUpBlocMock _signUpBloc;
  final snackBarFailureFinder = find.byKey(Key("snack_bar_failure"));
  final snackBarLoadingFinder = find.byKey(Key("snack_bar_loading"));
  final mockNavigatorObserver = MockNavigatorObserver();
  
  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => _loginBloc
        ),
        BlocProvider<SignupBloc>(
          create: (context) => _signUpBloc,
        )
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
    _signUpBloc = SignUpBlocMock();
  });

  testWidgets('Show snack bar when state is LoginFailure', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginFailed(error: "Could not find user. Please try different credentials")
    ];
    
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarFailureFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarFailureFinder, findsOneWidget);
  });

  testWidgets('Navigate to second sign up page when ProfileToBeUpdated', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      ProfileToBeUpdated()
    ];

    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    //Assert
    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.text("Signup"), findsOneWidget);
  });

  
  testWidgets('Show snack bar when state is LoginLoading', (WidgetTester tester) async {

    //Arrange
    var expectedStates = [
      LoginInitial(), 
      LoginLoading()
    ];
    
    whenListen(_loginBloc, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarLoadingFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarLoadingFinder, findsOneWidget);
  });
}
