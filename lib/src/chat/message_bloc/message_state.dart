import 'package:reazzon/src/chat/base/base_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class MessagesState extends BLOCStates {}

class MessagesNotLoaded extends MessagesState {
  @override
  String toString() {
    return '{ MessageState: Not Loaded }';
  }
}

class MessagesLoading extends MessagesState {
  @override
  String toString() {
    return '{ MessageState: Loading }';
  }
}

class MessagesLoaded extends MessagesState {
  final List<MessageEntity> messageEntities;

  MessagesLoaded(this.messageEntities);

  @override
  String toString() {
    return '{ MessageState: Loaded, message_entities: $messageEntities}';
  }
}
