import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class FirestoreMock extends Mock implements Firestore{}
class CollectionReferenceMock extends Mock implements CollectionReference{}
class DocumentReferenceMock extends Mock implements DocumentReference{
  DocumentSnapshotMock documentSnapshotMock;

  DocumentReferenceMock({this.documentSnapshotMock});

  @override
  Future<DocumentSnapshot> get({Source source = Source.serverAndCache}) {
    return Future<DocumentSnapshotMock>.value(documentSnapshotMock);
  }

  @override
  Future<void> setData(Map<String,dynamic> data, {bool merge = false}) {
    if(this.documentSnapshotMock == null)
      this.documentSnapshotMock = DocumentSnapshotMock();
    data.forEach((k,v){
      if(!documentSnapshotMock.mockData.containsKey(k))
        documentSnapshotMock.mockData[k]=v;
    });
    return null;
  }

  @override
  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) {

    if(documentSnapshotMock != null)
      return Stream.fromFuture(Future<DocumentSnapshotMock>
        .value(documentSnapshotMock));
    
    return Stream.empty();
  }
}
class DocumentSnapshotMock extends Mock implements DocumentSnapshot{
  Map mockData = Map<String,dynamic>();

  set data(Map data)  => this.mockData = data;
  @override
  Map<String,dynamic > get data => mockData;
}
