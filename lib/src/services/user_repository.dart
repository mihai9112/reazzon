import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/iuser_repository.dart';

final CollectionReference _userCollection =
    Firestore.instance.collection('Users');

class UserRepository implements IUserRepository {
  static final UserRepository _instance = new UserRepository.internal();

  UserRepository.internal();

  factory UserRepository() => _instance;

  @override
  Future<bool> createUserDetails(User user) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(user.userId));

      await tx.set(ds.reference, user.toMap());

      return {'added': true};
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      //TODO: log error
      print(onError);
      return false;
    });
  }

  @override
  Future<bool> deleteUserDetails(User user) {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(user.userId));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  @override
  Future<bool> updateUserDetails(User user) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(user.userId));

      await tx.update(ds.reference, user.toMap());
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
  Stream<QuerySnapshot> getUserDetails({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = _userCollection.snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Stream<List<AccountHomeEntity>> users() async* {
    final usersCollection = Firestore.instance.collection('Users');

    String ownId = await User.retrieveUserId();

    yield* usersCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => AccountHomeEntity.fromSnapshot(doc))
          .skipWhile((accountEntity) => accountEntity.userId == ownId)
          .toList();
    });
  }

  Stream<List<AccountHomeEntity>> filterUsers(List<String> reazzons) async* {
    final usersCollection = Firestore.instance.collection('Users');

    String ownId = await User.retrieveUserId();

    yield* usersCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => AccountHomeEntity.fromSnapshot(doc))
          .skipWhile((accountEntity) => accountEntity.userId == ownId)
          .where((accountHomeEntity) {
        for (String reazzon in reazzons) {
          if (accountHomeEntity.reazzons.contains(reazzon)) {
            return true;
          }
        }

        return false;
      }).toList();
    });
  }

  Future<bool> sendRequest(String toUserId) async {
    String myUserId = await User.retrieveUserId();

    String at = DateTime.now().millisecondsSinceEpoch.toString();

    var documentReference = Firestore.instance
        .collection('notifications')
        .document(toUserId)
        .collection(toUserId)
        .document(myUserId);

    String userName = (await Firestore.instance
            .collection('Users')
            .document(myUserId)
            .snapshots()
            .first)['userName'] ??
        '[NULL]';

    return Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, {
        'requestFromId': myUserId,
        'requestFrom': userName,
        'requestAt': at,
        'request': true
      });
    }).then((onValue) {
      return true;
    }).catchError((onError) {
      return {'success': false, 'error': onError};
    });
  }
}

class AccountHomeEntity {
  String fullName;
  String imgURL;
  String userId;
  List<String> reazzons;

  AccountHomeEntity({
    this.fullName,
    this.imgURL,
    this.reazzons,
    this.userId,
  });

  static AccountHomeEntity fromSnapshot(DocumentSnapshot snap) {
    List list = [];
    List<String> _list = [];

    if (snap.data['reazzons'] != null) {
      list = snap.data['reazzons'];
      list.forEach((item) {
        _list.add(item.toString());
      });
    }

    return AccountHomeEntity(
      fullName: snap.data['userName'] ?? '[NULL]',
      userId: snap.data['userId'],
      imgURL: snap.data['imageURL'] as String ??
          'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/reference_guide/baby_development_your_3_month_old_ref_guide/650x350_baby_development_your_3_month_old_ref_guide.jpg',
      reazzons: _list,
    );
  }
}

UserRepository userRepository = new UserRepository();
