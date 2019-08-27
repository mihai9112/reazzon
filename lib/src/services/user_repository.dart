import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:reazzon/src/services/iuser_repository.dart';

final CollectionReference _userCollection = Firestore.instance.collection('Users');

class UserRepository implements IUserRepository{
   
  static final UserRepository _instance = 
    new UserRepository.internal();

  UserRepository.internal();

  factory UserRepository() => _instance;

  @override
  Future<bool> createUserDetails(User user) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(_userCollection.document(user.userId));
      
      await tx.set(ds.reference, user.toMap());

      return { 'added': true };
    };

    return Firestore.instance.runTransaction(createTransaction)
      .then((_) => true)
      .catchError((onError){
        //TODO: log error
        print(onError);
        return false;
      });
  }

  @override
  Future<bool> deleteUserDetails(User user) {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(_userCollection.document(user.userId));

      await tx.delete(ds.reference);
      return { 'deleted': true };
    };

    return Firestore.instance
      .runTransaction(deleteTransaction)
      .then((_) => true)
      .catchError((onError){
        print(onError);
        return false;
      });
  }

  @override
  Future<bool> updateUserDetails(User user) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(_userCollection.document(user.userId));

      await tx.update(ds.reference, user.toMap());
      return { 'updated': true };
    };

    return Firestore.instance
      .runTransaction(updateTransaction)
      .then((_) => true)
      .catchError((onError){
        print(onError);
        return false;
      });
  }

  @override
  Stream<QuerySnapshot> getUserDetails({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = _userCollection.snapshots();

    if(offset != null)
      snapshots = snapshots.skip(offset);
    
    if(limit != null)
      snapshots = snapshots.take(limit);
    
    return snapshots;
  }
}

UserRepository userRepository = new UserRepository();