import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';
import 'package:reazzon/src/helpers/constants.dart';
import 'package:reazzon/src/helpers/paths.dart';
import 'package:reazzon/src/user/user.dart';

class UserDataProvider {
  final Firestore firestoreUserCollection;

  UserDataProvider({Firestore firestore})
    : firestoreUserCollection = firestore ?? Firestore.instance;

  Future<User> saveDetailsFromProvider(FirebaseUser user) async {
    DocumentReference ref = firestoreUserCollection.collection(Paths.usersPath).document(
      user.uid
    );
    final bool userIsEmpty =
      await ref.snapshots().isEmpty;
    
    if(userIsEmpty || user != null) {
      var userData = {
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName
      };
      ref.setData(userData, merge: true);
    }
    
    final DocumentSnapshot userDocument =
      await ref.get();
    var currentUser = User.fromFirestore(userDocument);

    Future.wait([
      SharedObjects.prefs.setString(Constants.sessionUid, currentUser.documentId),
      SharedObjects.prefs.setString(Constants.sessionDisplayName, currentUser.name),
      SharedObjects.prefs.setString(Constants.sessionEmail, currentUser.email)
    ])
    .then((onData) => true)
    .catchError((onError) {
      print(onError);
    });
    
    return currentUser;
  }

  Future<User> updateDetails(User user) async {
    DocumentReference ref = firestoreUserCollection.collection(Paths.usersPath).document(
      user.documentId
    );
    final bool userIsNotEmpty =
      !await ref.snapshots().isEmpty;
    
    final sd = json.encode(user.reazzons.toList());

    if(userIsNotEmpty) {
      var userData = {
        'username': user.userName,
        'reazzons': sd,
      };
      ref.setData(userData, merge: true);
    }

    final DocumentSnapshot userDocument =
      await ref.get();
    var currentUser = User.fromFirestore(userDocument);

    Future.wait([
      SharedObjects.prefs.setString(Constants.sessionUsername, currentUser.userName)
    ])
    .then((onData) => true)
    .catchError((onError) {
      print(onError);
    });

    return currentUser;
  }

  Future<bool> isProfileComplete() async {
    DocumentReference ref = firestoreUserCollection.collection(Paths.usersPath).document(
      SharedObjects.prefs.getString(Constants.sessionUid)
    );
    final DocumentSnapshot userDocument = await ref.get();
    final bool isProfileComplete = 
      userDocument != null &&
      userDocument.exists &&
      userDocument.data.containsKey('reazzons');
    
    if(isProfileComplete) {
      Future.wait([
        SharedObjects.prefs.setString(Constants.sessionDisplayName, userDocument.data['name']),
        SharedObjects.prefs.setString(Constants.sessionEmail, userDocument.data['email'])
      ])
      .then((onData) => true)
      .catchError((onError) {
        print(onError);
      });
    }
    return isProfileComplete;
  }
}