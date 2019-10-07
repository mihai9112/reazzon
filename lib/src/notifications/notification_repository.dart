import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_state.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> getNotifications();
  Future<bool> setNotificationRead(int notificationId);
  Future<bool> requestHandler(String userId, bool accept);
}

class FirebaseNotificationRepository extends NotificationRepository {
  final notificationsCollection =
      Firestore.instance.collection('notifications');
  final usersCollection = Firestore.instance.collection('Users');

  final String loggedUserId;

  FirebaseNotificationRepository(this.loggedUserId);

  @override
  Stream<List<NotificationModel>> getNotifications() {
    return notificationsCollection
        .document(loggedUserId)
        .collection(loggedUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => NotificationModel.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<bool> setNotificationRead(int notificationId) {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notificationsCollection
          .document('$loggedUserId/$loggedUserId/$notificationId'));

      await tx.update(ds.reference, {'isRead': true});
      return {'updated': true};
    };
    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  @override
  Future<bool> requestHandler(String userId, bool accept) {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notificationsCollection
          .document(loggedUserId)
          .collection(loggedUserId)
          .document(userId));

      final DocumentSnapshot myDs =
          await tx.get(usersCollection.document(loggedUserId));

      final DocumentSnapshot myFriendDs =
          await tx.get(usersCollection.document(userId));

      List<dynamic> myConnected = List.from((myDs['connected']) ?? []);
      List<dynamic> friendConnectedList =
          List.from((myFriendDs['connected']) ?? []);

      myConnected.add(userId);
      friendConnectedList.add(loggedUserId);

      await tx.update(ds.reference, {'accepted': accept});
      await tx.update(myDs.reference, {'connected': myConnected});
      await tx.update(myFriendDs.reference, {'connected': friendConnectedList});

      return {'updated': true};
    };
    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }
}
