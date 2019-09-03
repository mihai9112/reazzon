import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/chat/message_bloc/message_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_events.dart';
import 'package:reazzon/src/chat/message_bloc/message_state.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';
import 'package:reazzon/src/helpers/spinner.dart';

import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'chat_repository.dart';

class MessagePage extends StatefulWidget {
  final ChatEntity data;

  MessagePage(this.data);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessageBloc messageBloc;

  @override
  void didChangeDependencies() {
    messageBloc = MessageBloc(this.widget.data.userId,
        chatRepository: FireBaseChatRepositories());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    messageBloc.dispose();
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
          title: Text('Ujwal'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.more_horiz),
            )
          ],
        ),
        body: BlocProvider(
          bloc: this.messageBloc,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: _MessageListWidget(),
              ),
              Positioned(
                bottom: 0,
                child: _InputWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = BlocProvider.of<MessageBloc>(context).userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder(
          stream: BlocProvider.of<MessageBloc>(context).stream,
          builder: (context, AsyncSnapshot<MessagesState> snapshot) {
            if (!snapshot.hasData) {
              BlocProvider.of<MessageBloc>(context)
                  .dispatch(LoadMessageListEvent());
            }

            if (snapshot.hasData && snapshot.data is MessagesLoaded) {
              return ListView.separated(
                reverse: true,
                itemCount:
                    (snapshot.data as MessagesLoaded).messageEntities.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  MessageEntity data =
                      (snapshot.data as MessagesLoaded).messageEntities[index];

                  return _MessageListItem(
                    sent: (data.from.toString().compareTo(userId) == 0)
                        ? false
                        : true,
                    text: data.content,
                  );
                },
              );
            }

            return Center(child: Spinner());
          }),
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

class _InputWidget extends StatefulWidget {
  @override
  __InputWidgetState createState() => __InputWidgetState();
}

class __InputWidgetState extends State<_InputWidget> {
  TextEditingController messageController;
  String userId;
  MessageBloc _messageBloc;

  @override
  void initState() {
    messageController = TextEditingController();
    _messageBloc = BlocProvider.of<MessageBloc>(context);
    userId = _messageBloc.userId;

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
              _messageBloc.dispatch(SendMessageEvent(MessageEntity(
                from: 'OMA4VjyncrWeIlGIrGtVwLpLe3D3',
                to: this.userId,
                content: this.messageController.text,
                time: DateTime.now(),
              )));

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
