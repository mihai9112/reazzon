import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class MessagesEvent extends BlocEvents {}

class LoadMessageListEvent extends MessagesEvent {
  final String userId;

  LoadMessageListEvent(this.userId);

  @override
  String toString() {
    return '{ MessageEvent: Load Message List with $userId}';
  }
}

class SendMessageEvent extends MessagesEvent {
  final MessageEntity messageEntity;

  SendMessageEvent(this.messageEntity);

  @override
  String toString() {
    return '{ MessageEvent: Send Message List, message: $messageEntity}';
  }
}
