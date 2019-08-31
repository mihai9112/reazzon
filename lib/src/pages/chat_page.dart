import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _size = 72;

    ThemeData darkTheme = ThemeData.dark().copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 16,
          color: Color(0XFFCCCCCC),
        ),
      ),
    );

    ThemeData lightTheme = ThemeData.light().copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 16,
          color: Color(0XFF575B5E),
        ),
      ),
    );

    return MaterialApp(
      theme: lightTheme,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: null, child: Text('Message')),
                Tab(icon: null, child: Text('Groups')),
              ],
            ),
            title: Text('Reazzon Chat'),
          ),
          body: TabBarView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                child: ListView.separated(
                  itemCount: getMessageItemList().length,
                  itemBuilder: (BuildContext context, int index) {
//            return Container(height: 96);
                    return ChatItem(
                      messageItem: getMessageItemList()[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        color: Color(0XFFE0E0E0),
                        width: MediaQuery.of(context).size.width - _size - 16,
                      ),
                    );
                  },
                ),
              ),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

List<ChatItemModel> getMessageItemList() {
  List<ChatItemModel> messageItemModelList = [];

  List<String> names = [
    'Niraj Subedi',
    'Apsara Basnet',
    'Nar Bdr Basnet',
    'Sabuna Basnet',
    'Samjhana Pokharel',
    'Ujwal Basnet',
    'Bijeta Gelal',
    'Prajwal Magar',
    'Biman Rai',
    'Kalpana Pathak',
    'Ishwor Karki',
    'Ritika Basnet'
  ];

  for (int i = 1; i <= 11; i++) {
    messageItemModelList.add(
      ChatItemModel(
        imageUrl:
            'https://i.pinimg.com/236x/5e/32/7a/5e327a1f41086bb9adfb9b0be524860d.jpg',
        name: names[i - 1],
        latestMessage:
            'How are you doing? How do you do etc etc lorem lorem ipsum',
        unreadMessages: i % 11,
        isActive: (i % 3 == 0),
      ),
    );
  }

  return messageItemModelList;
}

class ChatItemModel {
  String imageUrl;
  String name;
  String latestMessage;
  int unreadMessages;
  bool isActive;

  ChatItemModel({
    this.imageUrl,
    this.name,
    this.latestMessage,
    this.unreadMessages,
    this.isActive,
  });
}

class ChatItem extends StatelessWidget {
  final ChatItemModel messageItem;

  ChatItem({this.messageItem});

  TextStyle itemNameStyle;

  TextStyle itemMessageStyle;

  @override
  Widget build(BuildContext context) {
    double _size = 54;

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
                    this.messageItem.imageUrl,
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
                      color: this.messageItem.isActive
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
                          this.messageItem.name,
                          style: itemNameStyle,
                          maxLines: 1,
                        ),
                        Text(
                          "24 min ago",
                          style: TextStyle(fontSize: 10),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            this.messageItem.latestMessage,
                            style: itemMessageStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        this.messageItem.unreadMessages == 0
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
                                    (this.messageItem.unreadMessages >= 10)
                                        ? '9+'
                                        : this
                                            .messageItem
                                            .unreadMessages
                                            .toString(),
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
