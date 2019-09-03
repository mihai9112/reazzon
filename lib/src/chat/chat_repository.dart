import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> chatEntities();
  Stream<List<MessageEntity>> getMessages(String uid);
  Future<bool> sendMessage(MessageEntity message);
}

class FireBaseChatRepositories extends ChatRepository {
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
  Stream<List<MessageEntity>> getMessages(String uid) {
    // todo: store logged user id and retrieve here
    final String myID = 'OMA4VjyncrWeIlGIrGtVwLpLe3D3';

    String groupID = generateGroupId(uid, myID);

    return chatsCollection
        .document(groupID)
        .collection(groupID)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => MessageEntity.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<bool> sendMessage(MessageEntity message) {
    var documentReference = Firestore.instance
        .collection('chats')
        .document(generateGroupId(message.from, message.to))
        .collection(generateGroupId(message.from, message.to))
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, message.toJson());
    }).then((onValue) {
      return true;
    }).catchError((onError) {
      return {'success': false, 'error': onError};
    });

    return null;
  }

  String generateGroupId(String from, String to) {
    return (from.compareTo(to) > 0) ? '$from-$to' : '$to-$from';
  }
}
