import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/account_page_bloc.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/chat/chat_page.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/pages/account_home_page.dart';
import 'package:reazzon/src/settings/setting_bloc.dart';
import 'package:reazzon/src/settings/setting_page.dart';
import 'package:reazzon/src/settings/setting_repository.dart';

import 'home_page.dart';

class AccountPage extends StatefulWidget {
  final String loggedUserId;

  AccountPage({this.loggedUserId}) {
    print('onAccount Page $loggedUserId');
  }

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LoginBloc _loginBloc;
  AccountPageBloc _accountPageBloc;
  SettingsBloc _settingsBloc;

  static const int DEFAULT_INDEX = 2;
  Widget _selectedWidget;
  int _currentIndex;

  List<Widget> _widgets() {
    return [
      ChatPage(),
      Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Text('People Page'),
        ),
      ),
      AccountHomePage(),
      Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Text('Notifications Page'),
        ),
      ),
      SettingPage(
        loggedUserId: this.widget.loggedUserId,
      ),
    ];
  }

  var _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
      title: new Text(''),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: new Text(''),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: new Text(''),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      title: new Text(''),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: new Text(''),
    )
  ];

  @override
  void initState() {
    _currentIndex = DEFAULT_INDEX;

    _accountPageBloc = AccountPageBloc(loggedUserId: this.widget.loggedUserId);
    _accountPageBloc.registerNotification(this.widget.loggedUserId);

    _loginBloc = new LoginBloc();

    print(this.widget.loggedUserId);
    _settingsBloc =
        SettingsBloc(FireBaseSettingRepository(this.widget.loggedUserId));

    _selectedWidget = _widgets()[DEFAULT_INDEX];

    super.initState();
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    _accountPageBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        drawer: _drawer(),
        body: BlocProvider<AccountPageBloc>(
          bloc: _accountPageBloc,
          child: _selectedWidget,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          currentIndex: _currentIndex,
          items: _bottomNavigationBarItems,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _selectedWidget = _widgets()[index];
            });
          },
        ),
      ),
    );
  }

  Drawer _drawer() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text('TEST'),
              accountEmail: new Text('test@gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
              ),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              title: Text('Sign out'),
              onTap: () {
                _loginBloc.signOut().then((_) {
                  var homeRoute = MaterialPageRoute(
                      builder: (BuildContext context) => HomePage());
                  Navigator.of(context)
                      .pushAndRemoveUntil(homeRoute, ModalRoute.withName('/'));
                }).catchError((onError) {
                  print(onError);
                });
              },
            )
          ],
        ),
      );
}
