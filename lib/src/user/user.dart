import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/reazzon.dart';

class User {
  String documentId;
  String name;
  String userName;
  String email;
  Set<Reazzon> reazzons = new Set<Reazzon>();

  User({
    this.documentId,
    this.name,
    this.userName,
    this.email,
    this.reazzons
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      documentId: doc.documentID,
      name: data['name'],
      userName: data['username'],
      email: data['email'],
      reazzons: data['reazzons']
    );
  }

  factory User.fromMap(Map data) {
    return User(
      documentId: data['uid'],
      name: data['name'],
      userName: data['username'],
      email: data['email'],
      reazzons: data['reazzons'].map((r) => new Reazzon(null, null)).toSet() //TODO: Map correctly
    );
  }
}