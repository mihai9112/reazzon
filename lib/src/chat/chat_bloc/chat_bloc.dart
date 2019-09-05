import 'dart:async';

import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
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
  Stream<ChatsState> mapEventToState(ChatsEvent event) {
    if (event is LoadChatList) {
      print('ChatBloc: load chat list event dispatched');

      return _chatRepository
          .chatEntities()
          .map((chatEntity) => ChatsLoaded(chatEntity));
    }

    return BehaviorSubject<ChatsState>()..add(ChatsNotLoaded());
  }
}
