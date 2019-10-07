import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class MessageRepository {
  String _loggedUserId;

  String get loggedUserId => _loggedUserId;

  Stream<List<MessageEntity>> getMessages(String userId);
  Stream<bool> sendMessage(MessageEntity message);

  static String generateGroupId(String from, String to) {
    return (from.compareTo(to) > 0) ? '$from-$to' : '$to-$from';
  }
}

class FireBaseMessageRepository extends MessageRepository {
  final chatsCollection = Firestore.instance.collection('chats');

  FireBaseMessageRepository({@required String loggedUserID})
      : assert(loggedUserID != null) {
    this._loggedUserId = loggedUserID;
  }

  @override
  Stream<List<MessageEntity>> getMessages(String userId) {
    String groupID =
        MessageRepository.generateGroupId(userId, this._loggedUserId);

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
  Stream<bool> sendMessage(MessageEntity message) {
    var documentReference = Firestore.instance
        .collection('chats')
        .document(MessageRepository.generateGroupId(message.from, message.to))
        .collection(MessageRepository.generateGroupId(message.from, message.to))
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    return Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, message.toJson());
    }).then((onValue) {
      return true;
    }).catchError((onError) {
      return {'success': false, 'error': onError};
    }).asStream();
  }

  void addChattingWith(String currentUserId, String chattingWith) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx
          .get(Firestore.instance.collection('Users').document(currentUserId));

      await tx.update(ds.reference, {'chattingWith': chattingWith});

      return {'added': true};
    };

    await Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  void removeChattingWith(String currentUserId) {
    Firestore.instance
        .collection('Users')
        .document(currentUserId)
        .updateData({'chattingWith': FieldValue.delete()});
  }
}
