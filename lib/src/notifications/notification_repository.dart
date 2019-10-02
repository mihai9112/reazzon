import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_state.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> getNotifications();
  Future<bool> setNotificationRead(int notificationId);
}

class FirebaseNotificationRepository extends NotificationRepository {
  final notificationsCollection =
      Firestore.instance.collection('notifications');

  final String loggedUserId;

  FirebaseNotificationRepository(this.loggedUserId);

  @override
  Stream<List<NotificationModel>> getNotifications() {
    print('Get Notification called');
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
    print('Update $notificationId and id $loggedUserId');
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
}
