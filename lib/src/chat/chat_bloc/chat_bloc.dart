import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_events.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_state.dart';
import 'package:reazzon/src/chat/repository/chat_repository.dart';

class ChatBloc extends BlocEventStateBase<ChatsEvent, ChatsState> {
  ChatRepository _chatRepository;

  ChatBloc({@required ChatRepository chatRepository})
      : assert(chatRepository != null) {
    _chatRepository = chatRepository;
  }

  @override
  ChatsState initialState() => ChatsNotLoaded();

  @override
  Stream<ChatsState> mapEventToState(
      ChatsEvent event, ChatsState currentState) async* {
    if (event is LoadChatList) {
      yield* _chatRepository
          .chattedWithEntities()
          .map((chatEntity) => ChatsLoaded(chatEntity));
    }

    yield ChatsNotLoaded();
  }
}
