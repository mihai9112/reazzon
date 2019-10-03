import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_events.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_state.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/chat/message_bloc/message_bloc.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';
import 'package:reazzon/src/helpers/spinner.dart';

import 'package:reazzon/src/chat/repository/chat_repository.dart';
import 'package:reazzon/src/models/user.dart';
import 'message_page.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc chatBloc;

  ChatPage(this.chatBloc);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Chat", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          this.widget.chatBloc.dispatch(LoadChatList());
          return Future.delayed(Duration(milliseconds: 0));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
          child: StreamBuilder(
            stream: this.widget.chatBloc.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data is ChatsLoaded) {
                ChatsLoaded loadedChats = (snapshot.data as ChatsLoaded);
                return ListView.separated(
                  itemCount: loadedChats.chatEntities.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatEntity data = loadedChats.chatEntities[index];

                    return InkWell(
                      onTap: () async {
                        String loggedUserId = await User.retrieveUserId();

                        MessageBloc messageBloc = MessageBloc(
                            messageRepository: FireBaseMessageRepository(
                          loggedUserID: loggedUserId,
                        ));

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MessagePage(data, messageBloc)));
                      },
                      child: ChatItem(
                        chatItem: data,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        color: Color(0XFFE0E0E0),
                        width: MediaQuery.of(context).size.width - 72 - 16,
                      ),
                    );
                  },
                );
              } else if (snapshot.hasData && snapshot.data is ChatsNotLoaded) {
                this.widget.chatBloc.dispatch(LoadChatList());
              }
              return Center(child: Spinner());
            },
          ),
        ),
      ),
    );
  }
}

ThemeData _getTheme(int i) {
  if (i == 1) {
    return ThemeData.dark().copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: 'reazzon',
          fontSize: 16,
          color: Color(0XFFCCCCCC),
        ),
      ),
    );
  } else {
    return ThemeData.light().copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: 'reazzon',
          fontSize: 16,
          color: Color(0XFF575B5E),
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final ChatEntity chatItem;

  ChatItem({this.chatItem});

  @override
  Widget build(BuildContext context) {
    double _size = 54;

    TextStyle itemNameStyle;
    TextStyle itemMessageStyle;

    itemNameStyle = Theme.of(context).textTheme.title.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );
    itemMessageStyle = Theme.of(context).textTheme.title.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Theme.of(context).textTheme.title.color.withOpacity(0.8),
        );

    return Container(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.network(
                    this.chatItem.imgURL,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    width: _size,
                    height: _size,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  left: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: this.chatItem.isActive
                          ? Color(0XFF5BF29F)
                          : Color(0XFF8D8D8D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          this.chatItem.userName,
                          style: itemNameStyle,
                          maxLines: 1,
                        ),
                        Text(
                          "24 min ago",
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            this.chatItem.latestMessage,
                            style: itemMessageStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        this.chatItem.unreadMessageCount == 0
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(left: 12.0),
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                    this.chatItem.unreadMessageCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
