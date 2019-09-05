import 'dart:async';

import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';

import 'message_events.dart';
import 'message_state.dart';

class MessageBloc extends BlocEventStateBase<MessagesEvent, MessagesState> {
  MessageRepository _messageRepository;

  MessageRepository get messageRepo => _messageRepository;

  MessageBloc({@required MessageRepository messageRepository})
      : assert(messageRepository != null) {
    _messageRepository = messageRepository;
  }

  @override
  MessagesState initialState() => MessagesNotLoaded();

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event) {
    if (event is LoadMessageListEvent) {
      return _messageRepository
          .getMessages()
          .map((messageEntity) => MessagesLoaded(messageEntity));
    }

    return BehaviorSubject<MessagesState>()..add(MessagesNotLoaded());
  }

  Stream<bool> sendMessage(MessageEntity messageEntity) {
    return _messageRepository.sendMessage(messageEntity);
  }
}
