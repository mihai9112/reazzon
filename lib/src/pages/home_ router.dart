import 'package:flutter/material.dart';
import 'package:reazzon/src/helpers/user.dart';
import 'package:reazzon/src/pages/home_page.dart';

import 'account_page.dart';

class HomeRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: UserHelper.hasUserId(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return FutureBuilder<String>(
              future: UserHelper.retrieveUserId(),
              builder: (context, snapshot) {
                return AccountPage(loggedUserId: snapshot.data);
              },
            );
          } else {
            return HomePage();
          }
        }
        return loadPage();
      },
    );
  }
}

Widget loadPage() => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.developer_board,
              color: Colors.blueAccent,
              size: 120.0,
            ),
            Text(
              'Reazzon',
              style: TextStyle(
                fontSize: 32,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontFamily: 'reazzon',
              ),
            )
          ],
        ),
      ),
    );
