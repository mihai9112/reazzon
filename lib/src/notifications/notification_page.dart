import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/notifications/notification_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationPage extends StatefulWidget {
  final NotificationBloc notificationBloc;

  NotificationPage(this.notificationBloc);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Notification", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
      ),
      body: StreamBuilder<NotificationStates>(
        stream: this.widget.notificationBloc.stream,
        initialData: UnNotificationState(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is LoadedNotificationsState) {
              if ((snapshot.data as LoadedNotificationsState)
                      .notifications
                      .length <=
                  0) {
                return Container(child: Center(child: Text('Empty')));
              }
              return ListView.builder(
                itemCount: (snapshot.data as LoadedNotificationsState)
                    .notifications
                    .length,
                itemBuilder: (context, i) {
                  int index = (snapshot.data as LoadedNotificationsState)
                          .notifications
                          .length -
                      i -
                      1;
                  NotificationModel notification =
                      (snapshot.data as LoadedNotificationsState)
                          .notifications[index];

                  return Container(
                    child: (notification.isRequest != null &&
                            notification.isRequest == true)
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            margin:
                                EdgeInsets.only(top: 16, right: 16, left: 16),
                            decoration: BoxDecoration(
                              color: (notification.requestAccepted == null)
                                  ? Colors.lightBlue[700]
                                  : (notification.requestAccepted)
                                      ? Colors.green
                                      : Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              'Request from ${notification.requestFromUserName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white,
                                              )),
                                          SizedBox(height: 4),
                                          (notification.requestAccepted == null)
                                              ? Container()
                                              : Text(
                                                  '${(notification.requestAccepted != null) ? (notification.requestAccepted) ? 'Accepted' : 'Rejected' : ''}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ))
                                        ],
                                      ),
                                    ),
                                    Text(readTimestamp(notification.requestAt),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                (notification.requestAccepted != null)
                                    ? Container()
                                    : Row(
                                        children: <Widget>[
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.lightGreenAccent,
                                              ),
                                            ),
                                            onPressed: () {
                                              this
                                                  .widget
                                                  .notificationBloc
                                                  .dispatch(AcceptRequestEvent(
                                                      notification
                                                          .requestFromId));
                                            },
                                          ),
                                          SizedBox(width: 12),
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.red[600],
                                              ),
                                            ),
                                            onPressed: () {
                                              this
                                                  .widget
                                                  .notificationBloc
                                                  .dispatch(RejectRequestEvent(
                                                      notification
                                                          .requestFromId));
                                            },
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              this.widget.notificationBloc.dispatch(
                                    OpenChatEvent(
                                      userId: notification.fromId,
                                      userName: notification.from,
                                      context: context,
                                      notificationId: notification.at,
                                    ),
                                  );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              margin:
                                  EdgeInsets.only(top: 16, right: 16, left: 16),
                              decoration: BoxDecoration(
                                color: (notification.isRead)
                                    ? Colors.grey
                                    : Colors.lightBlue[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      notification.imageURL ??
                                          'http://i.pravatar.cc/300',
                                      height: 48,
                                      width: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 9),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'Message from ${notification.from}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                        SizedBox(height: 2),
                                        Text(notification.content,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Text(readTimestamp(notification.at),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ],
                              ),
                            )),
                  );
                },
              );
            } else if (snapshot.data is UnNotificationState) {
              this.widget.notificationBloc.dispatch(LoadNotificationsEvent());
            }
          }

          return Container(child: Center(child: Spinner()));
        },
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
