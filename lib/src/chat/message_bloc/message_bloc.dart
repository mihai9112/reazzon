import 'dart:async';

import 'package:reazzon/src/chat/base/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/chat_repository.dart';

import 'message_events.dart';
import 'message_state.dart';

class MessageBloc extends BLOCBase<MessagesEvent, MessagesState> {
  final String userId;

  ChatRepository _chatRepository;

  MessageBloc(this.userId, {@required ChatRepository chatRepository})
      : assert(chatRepository != null),
        assert(userId != null) {
    _chatRepository = chatRepository;
  }

  @override
  MessagesState initialState() => MessagesNotLoaded();

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event) {
    if (event is LoadMessageListEvent) {
      return _chatRepository
          .getMessages(this.userId)
          .map((messageEntity) => MessagesLoaded(messageEntity));
    } else if (event is SendMessageEvent) {
      _chatRepository.sendMessage(event.messageEntity);
    }

    return BehaviorSubject<MessagesState>()..add(MessagesNotLoaded());
  }
}
