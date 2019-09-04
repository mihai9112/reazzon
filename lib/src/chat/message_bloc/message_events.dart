import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class MessagesEvent extends BLOCEvents {}

class LoadMessageListEvent extends MessagesEvent {
  @override
  String toString() {
    return '{ MessageEvent: Load Message List }';
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
