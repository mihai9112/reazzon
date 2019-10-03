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

  bool isRequest;
  String requestFromId;
  String requestFromUserName;
  int requestAt;
  bool requestAccepted;

  NotificationModel({
    this.content,
    this.from,
    this.at,
    this.fromId,
    this.imageURL,
    this.isRead,
    this.isRequest,
    this.requestAt,
    this.requestFromId,
    this.requestFromUserName,
    this.requestAccepted,
  });

  static NotificationModel fromSnapshot(DocumentSnapshot snap) {
    return NotificationModel(
      content: snap.data['content'] as String,
      from: snap.data['from'] ?? '',
      fromId: snap.data['fromId'] ?? '',
      imageURL: snap.data['imageURL'] ?? '',
      at: snap.data['at'] ?? null,
      isRead: snap.data['isRead'] ?? false,
      isRequest: snap.data['request'] ?? false,
      requestFromId: snap.data['requestFromId'] ?? '',
      requestFromUserName: snap.data['requestFrom'] ?? '',
      requestAt: (snap.data['requestAt'] != null)
          ? int.parse(snap.data['requestAt'])
          : null,
      requestAccepted: snap.data['accepted'] ?? null,
    );
  }
}
