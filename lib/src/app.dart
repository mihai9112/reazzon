import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/provider.dart';

class App extends StatelessWidget{
  build(context) {
    return Provider(
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: Container(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Container(
                child: LoginScreen(),
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                  minWidth: 150.0,
                  minHeight: 150.0,
                ),
              ),
            ),
          ), 
        ),
      ),
    );
  }
}