import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
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
            child: HomeScreen()
          ), 
        ),
      ),
    );
  }
}