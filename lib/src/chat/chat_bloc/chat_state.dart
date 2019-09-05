import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';

abstract class ChatsState extends BlocStates {}

class ChatsNotLoaded extends ChatsState {
  @override
  String toString() {
    return '{ ChatState: Not Loaded }';
  }
}

class ChatsLoading extends ChatsState {
  @override
  String toString() {
    return '{ ChatState: Loading }';
  }
}

class ChatsLoaded extends ChatsState {
  final List<ChatEntity> chatEntities;

  ChatsLoaded(this.chatEntities);

  @override
  String toString() {
    return '{ ChatState: Loaded, chat_entities: $chatEntities}';
  }
}
