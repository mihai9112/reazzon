import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/chat/base_bloc/base_bloc.dart';

class AccountHomeBloc extends BLOCBase {
  @override
  initialState() => null;

  @override
  Stream mapEventToState(event) => null;

  Stream<List<AccountHomeEntity>> users() {
    final usersCollection = Firestore.instance.collection('Users');

    return usersCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => AccountHomeEntity.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<List<AccountHomeEntity>> filterUsers(List<String> reazzons) {
    final usersCollection = Firestore.instance.collection('Users');

    return usersCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => AccountHomeEntity.fromSnapshot(doc))
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
}

class AccountHomeEntity {
  String fullName;
  String imgURL;
  List<String> reazzons;

  AccountHomeEntity({
    this.fullName,
    this.imgURL,
    this.reazzons,
  });

  static AccountHomeEntity fromSnapshot(DocumentSnapshot snap) {
    List list = snap.data['reazzons'];
    List<String> _list = [];
    list.forEach((item) {
      _list.add(item.toString());
    });

    return AccountHomeEntity(
      fullName: snap.data['firstName'] + ' ' + snap.data['lastName'],
      imgURL: snap.data['imgURL'] as String ??
          'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/reference_guide/baby_development_your_3_month_old_ref_guide/650x350_baby_development_your_3_month_old_ref_guide.jpg',
      reazzons: _list,
    );
  }
}
