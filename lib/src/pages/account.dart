import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';

import 'home_page.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LoginBloc _loginBloc;

  @override
  void initState(){
    super.initState();
    _loginBloc = new LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }

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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: new Text(_appBloc.appState.user.userName),
                  accountEmail: new Text(_appBloc.appState.user.emailAddress),
                  currentAccountPicture: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent
                  ),
                ),
                ListTile(
                  title: Text('Sign out'),
                  onTap: () {
                    _loginBloc.signOut().then((_){
                      var homeRoute = MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()
                      );
                      Navigator.of(context)
                        .pushAndRemoveUntil(homeRoute, ModalRoute.withName('/'));
                    }).catchError((onError){
                      //TODO:Log error
                      print(onError);
                    });
                  },
                )
              ],
            ),
          ),
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
                  Text(_appBloc.appState.user.firstName ?? ""),
                  Text(_appBloc.appState.user.lastName ?? ""),
                  Text(stringBuilder.toString())
                ],
              )
          ),
        ),
      ),
    );
  }
}