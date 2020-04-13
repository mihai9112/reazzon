import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/features/signup/presentation/bloc/signup.dart';
import 'package:reazzon/src/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:reazzon/src/features/signup/presentation/pages/signup_page.dart';

import '../authentication_tests/authentication_mock.dart';
import '../helpers/navigator_observer_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  SignUpBlocMock _signUpBlocMock;
  LoginBlocMock _loginBlockMock;
  final snackBarFailureFinder = find.byKey(Key("snack_bar_failure"));
  final mockNavigatorObserver = MockNavigatorObserver();

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => _loginBlockMock
        ),
        BlocProvider<SignupBloc>(
          create: (context) => _signUpBlocMock,
        )
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SignUpPage(),
        ),
        navigatorObservers: [mockNavigatorObserver]
      )
    );
  }

  setUp(() {
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _signUpBlocMock = SignUpBlocMock();
    _loginBlockMock = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Show snack bar when state is SignupFailed', (WidgetTester tester) async {
    //Arrage
    var expectedStates = [
      InitialSignupState(),
      SignupFailed()
    ];

    whenListen(_signUpBlocMock, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarFailureFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarFailureFinder, findsOneWidget);
  });

  testWidgets('Navigate to second sign up page when SignupSucceeded', (WidgetTester tester) async {
    //Arrange
    var expectedStates = [
      InitialSignupState(),
      SignupSucceeded()
    ];

    when(_signUpBlocMock.submitValid)
      .thenAnswer((_) => Stream.value(true));
    when(_signUpBlocMock.state)
      .thenReturn(ReazzonsLoaded([new Reazzon(1, "#TestReazzon")]));

    whenListen(_signUpBlocMock, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    //Assert
    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.text("Signup"), findsOneWidget);
  });
}