import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_model.dart';

class User {
  String firstName;
  String lastName;
  String userName;
  String userId;
  String image =
      'https://i.pinimg.com/236x/5e/32/7a/5e327a1f41086bb9adfb9b0be524860d.jpg';

  bool isActive = false;
  int unreadMessage = 3;

  User({
    this.firstName,
    this.lastName,
    this.userId,
    this.userName,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'firstName: $firstName, lastName: $lastName, user_id: $userId';
  }
}

class FireBaseChatRepository {
  @override
  Future<List<User>> getChattedUsers() async {
//    var temp = Firestore.instance
//        .collection('chat')
//        .document(generateGroupId())
//        .collection(generateGroupId());
//
//    print(temp);

    List<User> userList = [];

    var snapshots = Firestore.instance.collection('Users').getDocuments();

    await snapshots.then((val) {
      val.documents.forEach((f) {
        var temp = User(
          firstName: f.data['firstName'],
          lastName: f.data['lastName'] ?? '',
          userId: f.data['userId'],
          userName: f.data['userName'] ?? '',
        );

        userList.add(temp);
      });
    });

    return userList;
  }

  @override
  Stream<QuerySnapshot> getMessages(String uid) {
    String MyID = 'OMA4VjyncrWeIlGIrGtVwLpLe3D3';

    String groupID = generateGroupId(uid, MyID);

    return Firestore.instance
        .collection('chats')
        .document(groupID)
        .collection(groupID)
        .orderBy('time', descending: true)
        .snapshots();
  }

  @override
  Future<bool> sendMessage(Message message) {
    var documentReference = Firestore.instance
        .collection('chats')
        .document(generateGroupId(message.from, message.to))
        .collection(generateGroupId(message.from, message.to))
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, message.toJSON());
    }).then((onValue) {
      print('\n\n\nSuccess');
      print(onValue);
    }).catchError((onError) {
      print('\n\n\Failed');

      print(onError);
    });

    return null;
  }

  String generateGroupId(String from, String to) {
    return (from.compareTo(to) > 0) ? '$from-$to' : '$to-$from';
  }
}
