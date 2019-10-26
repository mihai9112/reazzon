

import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {}

class LoadChatList extends ChatsEvent {
  @override
  String toString() {
    return '{ChatsEvent: Load Chat List}';
  }
}
