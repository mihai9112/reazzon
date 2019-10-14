import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/pages/home_page.dart';

import 'src/authentication/authentication_repository.dart';
import 'src/pages/account_page.dart';

void main() async {
  final AuthenticationRepository _authenticationRepository =
    AuthenticationRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        builder: (context) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository
        )..dispatch(AppStarted()),
      )
    ],
    child: ReazzonMainWidget(),
  ));
}

class ReazzonMainWidget extends StatelessWidget {

  final ThemeData theme = ThemeData(
    primarySwatch: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reazzon',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is Authenticated){
            return AccountPage();
          }
          return HomePage();
        },
      ),
    );
  }
}