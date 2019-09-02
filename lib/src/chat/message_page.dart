import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/message_model.dart';
import 'package:reazzon/src/helpers/spinner.dart';

import 'chat_repository.dart';

class MessagePage extends StatefulWidget {
  var data;

  MessagePage(this.data);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'reazzon',
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          body1: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ujwal'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.more_horiz),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: _ChatListWidget(this.widget.data['userId']),
            ),
            Positioned(
                bottom: 0, child: _InputWidget(this.widget.data['userId'])),
          ],
        ),
      ),
    );
  }
}

class _ChatListWidget extends StatelessWidget {
  String uid;

  _ChatListWidget(this.uid);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<Object>(
          stream: FireBaseChatRepository().getMessages(uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                reverse: true,
                itemCount: snapshot.data.documents.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];

                  return _ChatListItem(
                    sent: (data['from'].toString().compareTo(this.uid) == 0)
                        ? false
                        : true,
                    text: data['content'],
                  );
                },
              );
            }

            return Center(child: Spinner());
          }),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  bool sent = false;
  String text = 'Good Day !';

  _ChatListItem({this.sent, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          this.sent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: sent ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.only(
                topRight: sent ? Radius.circular(0) : Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topLeft: sent ? Radius.circular(8) : Radius.circular(0),
              ),
            ),
            child: Text(this.text),
          ),
        ),
        SizedBox(height: 4)
      ],
    );
  }
}

class _InputWidget extends StatefulWidget {
  final String receiverID;

  _InputWidget(this.receiverID);

  @override
  __InputWidgetState createState() => __InputWidgetState();
}

class __InputWidgetState extends State<_InputWidget> {
  TextEditingController messageController;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: this.messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write your message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 4),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print('Send Clicked');
              FireBaseChatRepository().sendMessage(
                Message(
                  from: 'OMA4VjyncrWeIlGIrGtVwLpLe3D3',
                  to: this.widget.receiverID,
                  content: this.messageController.text,
                  timeStamp: DateTime.now(),
                ),
              );
              this.messageController.text = '';
            },
            child: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
