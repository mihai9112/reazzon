import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/src/helpers/cached_preferences.dart';
import 'package:reazzon/src/helpers/paths.dart';
import 'package:reazzon/src/user/user_data_provider.dart';

import '../authentication_tests/authentication_firebase_mock.dart';
import '../helpers/shared_preferences.dart';
import 'user_data_provider_mocks.dart';

void main() async {
  FirestoreMock firestoreMock = FirestoreMock();
  FirebaseUserMock firebaseUserMock = FirebaseUserMock();
  DocumentSnapshotMock documentSnapshotMock = DocumentSnapshotMock();
  DocumentReferenceMock documentReferenceMock = DocumentReferenceMock();
  CollectionReferenceMock collectionReferenceMock = CollectionReferenceMock();
  UserDataProvider userDataProvider = UserDataProvider(firestore: firestoreMock);
  CachedPreferencesMock cachedPreferencesMock = CachedPreferencesMock();
  SharedObjects.prefs = cachedPreferencesMock;

  group("UserDataProvider", () {

    test('saveDetailsFromProvider returns a user', () async {
      
      //Arrange
      when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);
      expect(await documentReferenceMock.snapshots().isEmpty, true);

      //Act
      var user = 
        await userDataProvider.saveDetailsFromProvider(firebaseUserMock);

      //Assert
      expect(user.email, firebaseUserMock.email);
      expect(user.name, firebaseUserMock.displayName);
    });

    test("saveDetailsFromProvider existing user returns the user", () async {

      //Arrange
      documentReferenceMock = DocumentReferenceMock(
        documentSnapshotMock: documentSnapshotMock
      );
      documentReferenceMock.setData({
        'email' : firebaseUserMock.email, 
        'name' : firebaseUserMock.displayName
      });
      when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);
      expect(await documentReferenceMock.snapshots().isEmpty, false);
      
      //Act
      var user = 
        await userDataProvider.saveDetailsFromProvider(firebaseUserMock);

      //Assert
      expect(user.email, firebaseUserMock.email);
      expect(user.name, firebaseUserMock.displayName);
    });

    test("isProfileComplete returns false if there is no document", () async {

      //Arrange
      when(SharedObjects.prefs.getString(any))
        .thenReturn(firebaseUserMock.uid);
      when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);
      when(documentSnapshotMock.exists)
        .thenReturn(false);

      //Act
      var isProfileCompleteResult = await userDataProvider.isProfileComplete();

      //Assert
      expect(isProfileCompleteResult, false);
    });

    test("isProfileComplete returns false if there are no reazzons saved", () async {

      //Arrange
      documentReferenceMock = DocumentReferenceMock(
        documentSnapshotMock: documentSnapshotMock
      );
      documentReferenceMock.setData({
        'email' : firebaseUserMock.email,
      });
      when(SharedObjects.prefs.getString(any))
        .thenReturn(firebaseUserMock.uid);
       when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);
      when(documentSnapshotMock.exists)
        .thenReturn(true);

      //Act
      var isProfileCompleteResult = await userDataProvider.isProfileComplete();

      //Assert
      expect(isProfileCompleteResult, false);
    });

    test("isProfileComplete returns true if there is a document and there are reazzons saved", () async {

      //Arrange
      documentReferenceMock = DocumentReferenceMock(
        documentSnapshotMock: documentSnapshotMock
      );
      documentReferenceMock.setData({
        'reazzons' : '["#Reazzon1"]',
      });
      when(SharedObjects.prefs.getString(any))
        .thenReturn(firebaseUserMock.uid);
       when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);
      when(documentSnapshotMock.exists)
        .thenReturn(true);

      //Act
      var isProfileCompleteResult = await userDataProvider.isProfileComplete();

      //Assert
      expect(isProfileCompleteResult, true);
    });
  });
}