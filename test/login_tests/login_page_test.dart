import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/pages/login_page.dart';

import '../authentication_tests/authentication_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  LoginBlocMock _loginBlocMock;
  
  Widget makeTestableWidget() {
    return BlocProvider<LoginBloc>(
      builder: (context) => _loginBlocMock,
      child: LoginPage(),
    );
  }

  setUp((){
    _loginBlocMock = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
  });

  testWidgets('', (WidgetTester tester) async {
    //Arrange
    
    //Act

    //Assert
  });
}
