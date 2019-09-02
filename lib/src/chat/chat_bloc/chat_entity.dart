import 'package:cloud_firestore/cloud_firestore.dart';

class ChatEntity {
  String userName;
  String userId;
  String imgURL;
  int unreadMessageCount;
  String latestMessage;
  bool isActive;

  ChatEntity({
    this.userName,
    this.userId,
    this.imgURL,
    this.unreadMessageCount,
    this.latestMessage,
    this.isActive,
  });

  Map<String, Object> toJson() {
    return {
      'userName': userName,
      'userId': userId,
      'imgURL': imgURL,
      'unreadMessageCount': unreadMessageCount,
      'latestMessage': latestMessage,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static ChatEntity fromJson(Map<String, Object> json) {
    return ChatEntity(
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      imgURL: json['image'] as String,
      unreadMessageCount: json['unreadMessageCount'] as int,
      latestMessage: json['latestMessage'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  static ChatEntity fromSnapshot(DocumentSnapshot snap) {
    return ChatEntity(
      userName: snap.data['userName'] as String,
      userId: snap.data['userId'] as String,
      imgURL: snap.data['imgURL'] as String ??
          'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/reference_guide/baby_development_your_3_month_old_ref_guide/650x350_baby_development_your_3_month_old_ref_guide.jpg',
      unreadMessageCount: snap.data['unreadMessageCount'] as int ?? 12,
      latestMessage: snap.data['latestMessage'] as String ?? 'Hello',
      isActive: snap.data['isActive'] as bool ?? false,
    );
  }

//  Map<String, Object> toDocument() {
//    return {
//      'complete': complete,
//      'task': task,
//      'note': note,
//    };
//  }
}
