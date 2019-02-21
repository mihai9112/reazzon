import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/pages/account.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/pages/signup_page.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MaterialApp(
        title: 'Reazzon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomeScreen(),
        routes: {
          '/account' : (BuildContext context) => AccountPage(),
          '/register' : (BuildContext context) => SignUpPage(),
        },
      ),
    );
  }

}