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
  Future<String> changePassword();

  Future<bool> changeFirstName(String newFirstName);
  Future<bool> changeLastName(String newLastName);
  Future<bool> changeUserName(String newUserName);

  Future<List<Reazzon>> changeReazzons();
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
              .updateData({'photoUrl': downloadUrl});

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

  Future<bool> changeEmail(String newEmail) async {
    print('Repo Change Email $newEmail');
    Firestore().runTransaction((Transaction tx) async {
      return {'added': true};
    });
  }

  Future<String> changePassword() => null;

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
    print('Repo Change User Name $newUserName');
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

  Future<List<Reazzon>> changeReazzons() => null;

  Stream<SettingUserModel> getUserDetails() {
    return Firestore.instance.collection('Users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => SettingUserModel.fromDoc(doc, 'Ujwl'))
          .toList()
          .first;
    });
  }
}
