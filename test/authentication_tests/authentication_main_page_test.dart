import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/main.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_bloc.dart';
import 'package:reazzon/src/pages/account_page.dart';
import 'package:reazzon/src/pages/home_page.dart';

import 'authentication_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  AuthenticationBlocMock _authenticationBlocMock;

  Widget makeTestableWidget({AuthenticationBloc bloc}) {
    return BlocProvider(
      builder: (context) => bloc,
      child: ReazzonMainWidget()
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _authenticationBlocMock = AuthenticationBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('Returns HomePage when Unauthenticated', (WidgetTester tester) async {
    //Arrange
    when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(false));
    when(_authenticationBlocMock.currentState)
        .thenAnswer((_) => Unauthenticated());

    //Act
    await tester.pumpWidget(makeTestableWidget(bloc: _authenticationBlocMock));

    //Assert
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Return AccountPage when Authenticated', (WidgetTester tester) async {
    //Arrange
    when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(true));
    when(_authenticationBlocMock.currentState)
        .thenAnswer((_) => Authenticated("testUser"));

    //Act
    await tester.pumpWidget(makeTestableWidget(bloc: _authenticationBlocMock));

    //Assert
    expect(find.byType(AccountPage), findsOneWidget);
  });
  
}