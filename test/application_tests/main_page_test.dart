import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/main.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/authentication/authentication_bloc.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/repositories/authentication_repository.dart';

import '../mocks/authentication_repository_mock.dart';

void main(){
  Widget makeTestableWidget({Widget child, AuthenticationRepository repository}) {
    return BlocProvider(
      builder: (context) => AuthenticationBloc(authenticationRepository: repository)..dispatch(AppStarted()),
      child: child,
    );
  }

  testWidgets('Returns HomePage when AppStarted and Unauthenticated', (WidgetTester tester) async {
    //Arrange
    final _authenticationRepositoryMock = AuthenticationRepositoryMock();
    when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(false));

    //Act
    await tester.pumpWidget(makeTestableWidget(child: ReazzonMainWidget(), repository: _authenticationRepositoryMock));

    //Assert
    expect(find.byType(HomePage), findsOneWidget);
  });
  
}