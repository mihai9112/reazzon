import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';
import 'package:reazzon/src/signup/presentation/pages/signup_continue_page.dart';

import '../authentication_tests/authentication_mock.dart';
import '../helpers/navigator_observer_mock.dart';

void main() async {
  
  SignUpBlocMock _signUpBlocMock;
  final mockNavigatorObserver = MockNavigatorObserver();
  final reazzon = Reazzon(1, '#Reazzon');
  
  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(
          create: (context) => _signUpBlocMock,
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

  testWidgets('Set text to bold when selecting reazzon', (WidgetTester tester) async {
    //Arrage
    when(_signUpBlocMock.state)
      .thenReturn(ReazzonsLoaded([Reazzon.selected(reazzon)]));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    //Assert
    var finder = find.byKey(Key('${reazzon.id}_${reazzon.value}_text'));
    expect(finder, findsOneWidget);

    //Checks if the text is bold when selected. Bold = index FontWeight._(6)
    var textWidget = finder.evaluate().single.widget as Text;
    expect(textWidget.style.fontWeight.index, 6);
  });

  testWidgets('Set text to normal when deselected reazzon', (WidgetTester tester) async {
    //Arrage
    when(_signUpBlocMock.state)
      .thenReturn(ReazzonsLoaded([reazzon]));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    //Assert
    var finder = find.byKey(Key('${reazzon.id}_${reazzon.value}_text'));
    expect(finder, findsOneWidget);

    //Checks if the text is normal when selected. Bold = index FontWeight._(3)
    var textWidget = finder.evaluate().single.widget as Text;
    expect(textWidget.style.fontWeight.index, 3);
  });

  testWidgets('Show failure snackbar when reazzon limit selection reached', (WidgetTester tester) async {
    //Arrange
    final snackBarLimitFinder = find.byKey(Key("snack_bar_limit_reached"));

    whenListen(_signUpBlocMock, Stream.fromIterable([InitialSignupState(), ReazzonLimitSelected(), ReazzonsLoaded([reazzon])]));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(snackBarLimitFinder, findsNothing);
    await tester.pump();

    //Assert
    expect(snackBarLimitFinder, findsOneWidget);
  });

  testWidgets('Navigate to home page when sign up completed', (WidgetTester tester) async {
    //Arrage
    var expectedStates = [
      InitialSignupState(),
      SignupCompleted()
    ];

    when(_signUpBlocMock.completeValid)
      .thenAnswer((_) => Stream.value(true));
    whenListen(_signUpBlocMock, Stream.fromIterable(expectedStates));

    //Act
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    //Assert
    verify(mockNavigatorObserver.didPush(any, any));
    expect(find.byType(HomePage), findsOneWidget);
  });
}