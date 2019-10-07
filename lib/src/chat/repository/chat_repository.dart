import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/models/user.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> chatEntities();
  Stream<List<ChatEntity>> chattedWithEntities();
}

class FireBaseChatRepository extends ChatRepository {
  @override
  Stream<List<ChatEntity>> chatEntities() async* {
    String ownId = await User.retrieveUserId();

    print('All of the Entities');

    yield* Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ChatEntity.fromSnapshot(doc))
          .skipWhile((chatEntity) => chatEntity.userId == ownId)
          .toList();
    });
  }

  Stream<List<ChatEntity>> chattedWithEntities() async* {
    String currentUserId = await User.retrieveUserId();

    List<dynamic> chattedWithIds = (await Firestore.instance
            .collection('Users')
            .document(currentUserId)
            .snapshots()
            .map((snapshot) => snapshot['connected'])
            .first) ??
        [];

    yield* Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ChatEntity.fromSnapshot(doc))
          .where((chatEntity) {
        bool chatted = false;
        chattedWithIds.forEach((chattedId) {
          if (chattedId.toString().compareTo(chatEntity.userId) == 0) {
            chatted = true;
          }
        });
        return chatted;
      }).toList();
    });
  }
}
