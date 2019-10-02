import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NotificationStates {}

class UnNotificationState extends NotificationStates {
  @override
  String toString() {
    return 'UnInitialized Notification State';
  }
}

class LoadingNotificationState extends NotificationStates {
  @override
  String toString() {
    return 'Loading Notification State';
  }
}

class LoadedNotificationsState extends NotificationStates {
  final List<NotificationModel> notifications;

  LoadedNotificationsState(this.notifications);

  @override
  String toString() {
    return 'Loaded Notification State';
  }
}

class NotificationModel {
  String content;
  String fromId;
  String imageURL;
  String from;
  int at;
  bool isRead;

  NotificationModel(
      {this.content,
      this.from,
      this.at,
      this.fromId,
      this.imageURL,
      this.isRead});

  static NotificationModel fromSnapshot(DocumentSnapshot snap) {
    return NotificationModel(
      content: snap.data['content'] as String,
      from: snap.data['from'],
      fromId: snap.data['fromId'],
      imageURL: snap.data['imageURL'],
      at: snap.data['at'],
      isRead: snap.data['isRead'] ?? false,
    );
  }
}
