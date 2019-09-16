import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> chatEntities();
  Stream<List<ChatEntity>> chattedEntities(String loggedUserId);
}

class FireBaseChatRepository extends ChatRepository {
  final usersCollection = Firestore.instance.collection('Users');
  final chatsCollection = Firestore.instance.collection('chats');

  @override
  Stream<List<ChatEntity>> chatEntities() {
    return Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ChatEntity.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<ChatEntity>> chattedEntities(String loggedUserId) {
    return null;
  }
}
