import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appBloc = BlocProvider.of<ApplicationBloc>(context);
    var stringBuilder = new StringBuffer();
    _appBloc.appState.user.selectedReazzons.forEach((f) {
      stringBuilder.write(f.value);
      stringBuilder.write("; ");
    });

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Overview", style: TextStyle(color: Colors.blueAccent)),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  Container(height: 20.0),
                  Container(padding: const EdgeInsets.all(55.0)),
                  Text(_appBloc.appState.user.firstName),
                  Text(_appBloc.appState.user.lastName),
                  Text(_appBloc.appState.user.userName),
                  Text(stringBuilder.toString())
                ],
              )
          ),
        ),
      ),
    );
  }
}