import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/account_page_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/login_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_bloc.dart';
import 'package:reazzon/src/chat/chat_page.dart';
import 'package:reazzon/src/chat/repository/chat_repository.dart';
import 'package:reazzon/src/notifications/notification_bloc.dart';
import 'package:reazzon/src/notifications/notification_page.dart';
import 'package:reazzon/src/notifications/notification_repository.dart';
import 'package:reazzon/src/pages/account_home_page.dart';
import 'package:reazzon/src/settings/setting_page.dart';

class AccountPage extends StatefulWidget {
  final String loggedUserId;

  AccountPage({this.loggedUserId});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LoginBloc _loginBloc;
  AccountPageBloc _accountPageBloc;
  NotificationBloc _notificationBloc;
  ChatBloc _chatBloc;

  static const int DEFAULT_INDEX = 1;
  Widget _selectedWidget;
  int _currentIndex;

  List<Widget> _widgets() {
    return [
      ChatPage(_chatBloc),
      AccountHomePage(),
      NotificationPage(_notificationBloc),
      SettingPage(
        loggedUserId: this.widget.loggedUserId,
        loginBloc: _loginBloc,
      ),
    ];
  }

  var _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
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

    _accountPageBloc = AccountPageBloc();
    _accountPageBloc.registerNotification(this.widget.loggedUserId);

    _loginBloc = new LoginBloc();

    _notificationBloc = NotificationBloc(
        FirebaseNotificationRepository(this.widget.loggedUserId));

    _chatBloc = ChatBloc(chatRepository: FireBaseChatRepository());

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
}
