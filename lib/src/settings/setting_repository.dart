import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reazzon/src/models/reazzon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/settings/setting_bloc.dart';

abstract class SettingRepository {
  Future<String> changeProfilePicture(File file);

  Future<bool> changeEmail(String newEmail);
  Future<bool> changePassword(String newPassword);
  Future<bool> changeFirstName(String newFirstName);
  Future<bool> changeLastName(String newLastName);
  Future<bool> changeUserName(String newUserName);
  Future<bool> changeReazzons(List<String> reazzons);
  Stream<SettingUserModel> getUserDetails();
}

class FireBaseSettingRepository extends SettingRepository {
  String userId;
  final CollectionReference _userCollection =
      Firestore.instance.collection('Users');

  FireBaseSettingRepository(this.userId);

  Future<String> changeProfilePicture(File file) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(userId);

    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot;

    try {
      var value = await uploadTask.onComplete;

      if (value.error == null) {
        storageTaskSnapshot = value;

        try {
          var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

          await Firestore.instance
              .collection('Users')
              .document(userId)
              .updateData({'imageURL': downloadUrl});

          return downloadUrl;
        } catch (err) {
          return Future.error('This file is not an image');
        }
      } else {
        return Future.error('This file is not an image');
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<bool> passwordVerification(String password) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user.email, password: password)
        .then((_) => true)
        .catchError((err) => false);
  }

  Future<bool> changeEmail(String newEmail) async {
    return Firestore()
        .runTransaction((Transaction tx) async {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();

          user.updateEmail(newEmail).then((_) {
            return {'changed': true};
          }).catchError((err) {
            return Future.error(err.toString());
          });
        })
        .then((_) => true)
        .catchError((_) => false);
  }

  Future<bool> changePassword(String newPassword) async {
    return Firestore()
        .runTransaction((Transaction tx) async {
          FirebaseUser user = await FirebaseAuth.instance.currentUser();

          user.updatePassword(newPassword).then((_) {
            return {'changed': true};
          }).catchError((err) {
            return Future.error(err.toString());
          });
        })
        .then((_) => true)
        .catchError((_) => false);
  }

  Future<bool> changeFirstName(String newFirstName) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(userId));

      await tx.update(ds.reference, {'firstName': newFirstName});

      return {'added': true};
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  Future<bool> changeLastName(String newLastName) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(userId));

      await tx.update(ds.reference, {'lastName': newLastName});

      return {'added': true};
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  Future<bool> changeUserName(String newUserName) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(userId));

      await tx.update(ds.reference, {'userName': newUserName});

      return {'added': true};
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  // todo
  Future<bool> changeReazzons(List<String> reazzons) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_userCollection.document(userId));

      await tx.update(ds.reference, {'reazzons': reazzons});

      return {'added': true};
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then((_) => true)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }

  Stream<SettingUserModel> getUserDetails() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    yield* Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .where((doc) => doc.documentID == userId)
          .map((doc) => SettingUserModel.fromDoc(doc, user.email))
          .toList()
          .first;
    });
  }
}
