import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';

abstract class ChatsEvent extends BLOCEvents {}

class LoadChatList extends ChatsEvent {
  @override
  String toString() {
    return '{ChatsEvent: Load Chat List}';
  }
}
