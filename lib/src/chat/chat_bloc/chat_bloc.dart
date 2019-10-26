import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_events.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_state.dart';
import 'package:reazzon/src/chat/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatRepository _chatRepository;

  ChatBloc({@required ChatRepository chatRepository})
      : assert(chatRepository != null) {
    _chatRepository = chatRepository;
  }

  @override
  ChatsState get initialState => ChatsNotLoaded();

  @override
  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    if (event is LoadChatList) {
      yield* _chatRepository
          .chattedWithEntities()
          .map((chatEntity) => ChatsLoaded(chatEntity));
    }

    yield ChatsNotLoaded();
  }
}
