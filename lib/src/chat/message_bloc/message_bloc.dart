import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';

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
  Stream<MessagesState> mapEventToState(
      MessagesEvent event, MessagesState currentState) async* {
    if (event is LoadMessageListEvent) {
      yield* _messageRepository
          .getMessages(event.userId)
          .map((messageEntity) => MessagesLoaded(messageEntity));
    }

    yield MessagesNotLoaded();
  }

  Stream<bool> sendMessage(MessageEntity messageEntity) {
    return _messageRepository.sendMessage(messageEntity);
  }
}
