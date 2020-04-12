import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'dart:convert';

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
    return User.fromMap(doc.data);
  }

  factory User.fromMap(Map data) {

    Set<Reazzon> savedReazzons = Set<Reazzon>();
    if(data['reazzons'] != null){
      var listOfReazzons = json.decode(data['reazzons'])
        .map((r) => Reazzon.fromJson(r))
        .cast<Reazzon>()
        .toList();
      savedReazzons.addAll(listOfReazzons);
    }

    return User(
      documentId: data['uid'],
      name: data['name'],
      userName: data['username'],
      email: data['email'],
      reazzons: savedReazzons
    );
  }
}