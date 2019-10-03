import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/models/user.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> chatEntities();
}

class FireBaseChatRepository extends ChatRepository {
  @override
  Stream<List<ChatEntity>> chatEntities() async* {
    String ownId = await User.retrieveUserId();

    yield* Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ChatEntity.fromSnapshot(doc))
          .skipWhile((chatEntity) => chatEntity.userId == ownId)
          .toList();
    });
  }
}
