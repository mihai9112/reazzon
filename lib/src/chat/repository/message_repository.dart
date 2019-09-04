import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/chat/message_bloc/message_entity.dart';

abstract class MessageRepository {
  String _userId;
  String _loggedUserId;

  String get userId => _userId;
  String get loggedUserId => _loggedUserId;

  Stream<List<MessageEntity>> getMessages();
  Stream<bool> sendMessage(MessageEntity message);

  static String generateGroupId(String from, String to) {
    return (from.compareTo(to) > 0) ? '$from-$to' : '$to-$from';
  }
}

class FireBaseMessageRepository extends MessageRepository {
  final chatsCollection = Firestore.instance.collection('chats');

  FireBaseMessageRepository(
      {@required String userId, @required String loggedUserID})
      : assert((userId != null) && (loggedUserID != null)) {
    this._userId = userId;
    this._loggedUserId = loggedUserID;
  }

  @override
  Stream<List<MessageEntity>> getMessages() {
    String groupID =
        MessageRepository.generateGroupId(this._userId, this._loggedUserId);

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
}
