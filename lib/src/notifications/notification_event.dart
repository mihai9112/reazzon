import 'package:flutter/cupertino.dart';

abstract class NotificationEvents {}

class LoadNotificationsEvent extends NotificationEvents {
  @override
  String toString() {
    return 'Load Notification Event';
  }
}

class OpenChatEvent extends NotificationEvents {
  final String userId;
  final String userName;
  final int notificationId;
  final BuildContext context;

  OpenChatEvent({
    this.userId,
    this.userName,
    this.context,
    this.notificationId,
  });

  @override
  String toString() {
    return 'Open Chat Event {Notifications Event}';
  }
}

class AcceptRequestEvent extends NotificationEvents {
  final String userId;
  AcceptRequestEvent(this.userId);

  @override
  String toString() {
    return 'Open Chat Event {Accept Request Event $userId}';
  }
}

class RejectRequestEvent extends NotificationEvents {
  final String userId;
  RejectRequestEvent(this.userId);

  @override
  String toString() {
    return 'Open Chat Event {Reject Request Event}';
  }
}
