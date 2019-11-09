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
  DocumentReferenceMock documentReferenceMock = DocumentReferenceMock(
    documentSnapshotMock: documentSnapshotMock
  );
  CollectionReferenceMock collectionReferenceMock = CollectionReferenceMock();
  UserDataProvider userDataProvider =
    UserDataProvider(firestore: firestoreMock);
  CachedPreferencesMock cachedPreferencesMock = CachedPreferencesMock();
  SharedObjects.prefs = cachedPreferencesMock;

  group("UserDataProvider", () {

    test('saveDetailsFromProvider returns a user', () async {
      
      //Arrange
      when(firestoreMock.collection(Paths.usersPath))
        .thenReturn(collectionReferenceMock);
      when(collectionReferenceMock.document(firebaseUserMock.uid))
        .thenReturn(documentReferenceMock);

      //Act
      var user = 
        await userDataProvider.saveDetailsFromProvider(firebaseUserMock);

      //Assert
      expect(user.email, firebaseUserMock.email);
      expect(user.name, firebaseUserMock.displayName);
    });
  });
}