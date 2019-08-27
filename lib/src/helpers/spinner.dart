import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.blueAccent,
        )
      ],
    ); 
  }

}