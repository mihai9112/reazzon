import 'package:flutter/material.dart';
import 'package:reazzon/src/features/account/presentation/pages/account_page.dart';

class ConversationsPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations")
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ConversationsPage(),
                  ));
                },
              )
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ));
                },
              ),
            )
          ],
        )
      ),
    );
  }
}