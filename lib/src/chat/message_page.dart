import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/message_bloc/message_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_events.dart';
import 'package:reazzon/src/chat/message_bloc/message_state.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';
import 'package:reazzon/src/helpers/spinner.dart';

import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';

class MessagePage extends StatefulWidget {
  final ChatEntity data;
  final MessageBloc messageBloc;

  MessagePage(this.data, this.messageBloc);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with WidgetsBindingObserver {
  MessageBloc messageBloc;
  TextEditingController messageController;

  @override
  void initState() {
    messageBloc = this.widget.messageBloc;
    messageController = TextEditingController();

    (messageBloc.messageRepo as FireBaseMessageRepository).addChattingWith(
        messageBloc.messageRepo.loggedUserId, this.widget.data.userId);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        (messageBloc.messageRepo as FireBaseMessageRepository).addChattingWith(
            messageBloc.messageRepo.loggedUserId, this.widget.data.userId);
        print('Resumed');
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        (messageBloc.messageRepo as FireBaseMessageRepository)
            .removeChattingWith(messageBloc.messageRepo.loggedUserId);
        print('Paused');
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }

  @override
  void dispose() {
    (messageBloc.messageRepo as FireBaseMessageRepository)
        .removeChattingWith(messageBloc.messageRepo.loggedUserId);
    super.dispose();
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
          title: Text(this.widget.data.userName ?? ''),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamBuilder(
                    stream: messageBloc.stream,
                    builder: (context, AsyncSnapshot<MessagesState> snapshot) {
                      if (!snapshot.hasData) {
                        messageBloc.dispatch(
                            LoadMessageListEvent(this.widget.data.userId));
                      }

                      if (snapshot.hasData && snapshot.data is MessagesLoaded) {
                        return ListView.separated(
                          reverse: true,
                          itemCount: (snapshot.data as MessagesLoaded)
                              .messageEntities
                              .length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8);
                          },
                          itemBuilder: (context, index) {
                            MessageEntity data =
                                (snapshot.data as MessagesLoaded)
                                    .messageEntities[index];

                            return _MessageListItem(
                              sent: (data.from
                                          .toString()
                                          .compareTo(this.widget.data.userId) ==
                                      0)
                                  ? false
                                  : true,
                              text: data.content,
                            );
                          },
                        );
                      }

                      return Center(child: Spinner());
                    }),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black12, width: 1)),
                ),
                child: Row(
                  children: <Widget>[
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
                        if (this.messageController.text.trim().length > 0)
                          messageBloc.sendMessage(MessageEntity(
                            from: this.messageBloc.messageRepo.loggedUserId,
                            to: this.widget.data.userId,
                            content: this.messageController.text,
                            time: DateTime.now(),
                          ));

                        this.messageController.text = '';
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
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

class _MessageListItem extends StatelessWidget {
  final bool sent;
  final String text;

  _MessageListItem({this.sent, this.text});

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
