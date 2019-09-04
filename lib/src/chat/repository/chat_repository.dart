import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/chat/repository/message_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> chatEntities();
  Stream<List<ChatEntity>> chattedEntities(String loggedUserId);
}

class FireBaseChatRepository extends ChatRepository {
  final usersCollection = Firestore.instance.collection('Users');
  final chatsCollection = Firestore.instance.collection('chats');

  @override
  Stream<List<ChatEntity>> chatEntities() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ChatEntity.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<ChatEntity>> chattedEntities(String loggedUserId) {
    return null;
  }

  Future<bool> _tester(ChatEntity chatEntity, String loggedUserId) async {
    String groupId =
        MessageRepository.generateGroupId(chatEntity.userId, loggedUserId);

    return (await chatsCollection.document(groupId).get()).exists;
  }

  Future<void> test() async {
    print('In Test');
    int l = await Firestore.instance.collection('chats').snapshots().length;
    print(l);
//    .listen(
//        (data) => data.documents.forEach((doc) => print(doc.documentID)));
  }
}
