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
    final bool userExists =
      await ref.snapshots().isEmpty;
    
    if(!userExists) {
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

  // Future<bool> isProfileComplete() async {
  //   DocumentReference ref = firestoreUserCollection.collection(Paths.usersPath).document(

  //   )
  // }
}