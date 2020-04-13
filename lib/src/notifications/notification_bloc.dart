import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/chat/message_bloc/message_bloc.dart';
import 'package:reazzon/src/chat/message_page.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/notifications/notification_state.dart';
import 'package:bloc/bloc.dart';

import 'notification_event.dart';
import 'notification_repository.dart';

void openMessage(context, userId, username) async {
  String loggedUserId = await User.retrieveUserId();

  MessageBloc messageBloc = MessageBloc(
      messageRepository: FireBaseMessageRepository(
    loggedUserID: loggedUserId,
  ));

  ChatEntity data = ChatEntity(userId: userId, userName: username);
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MessagePage(data, messageBloc)));
}

class NotificationBloc
    extends Bloc<NotificationEvents, NotificationStates> {
  final NotificationRepository notificationRepository;

  NotificationBloc(this.notificationRepository);

  @override
  NotificationStates get initialState => UnNotificationState();

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async* {
    if (event is LoadNotificationsEvent) {
      yield LoadingNotificationState();

      yield* notificationRepository
          .getNotifications()
          .map((notifications) => LoadedNotificationsState(notifications));
    }
    if (event is OpenChatEvent) {
      notificationRepository.setNotificationRead(event.notificationId);
      openMessage(event.context, event.userId, event.userName);
    }
    if (event is AcceptRequestEvent) {
      notificationRepository.requestHandler(event.userId, true);
    }
    if (event is RejectRequestEvent) {
      notificationRepository.requestHandler(event.userId, false);
    }
  }
}
