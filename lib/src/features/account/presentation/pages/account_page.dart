import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/features/conversations/presentation/pages/conversations_page.dart';

class AccountPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.grey[500]),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) => ConversationsPage(),
                  ), (_) => false);
                },
              )
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () => false
              ),
            )
          ],
        )
      ),
    );
  }
}