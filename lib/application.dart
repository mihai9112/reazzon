import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/pages/home_%20router.dart';
import 'package:reazzon/src/pages/signup_page.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reazzon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeRouter(),
        routes: {
          '/register': (BuildContext context) => SignUpPage(),
        },
      ),
    );
  }
}
