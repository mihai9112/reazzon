import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String content;
  final DateTime time;
  final String from;
  final String to;

  MessageEntity({
    this.content,
    this.time,
    this.from,
    this.to,
  });

  Map<String, Object> toJson() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'time': time,
    };
  }

  static MessageEntity fromJson(Map<String, Object> json) {
    return MessageEntity(
      from: json['from'] as String,
      to: json['to'] as String,
      content: json['content'] as String,
      time: json['time'] as DateTime,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static MessageEntity fromSnapshot(DocumentSnapshot snap) {
    return MessageEntity(
      from: snap.data['from'] as String,
      to: snap.data['to'] as String,
      content: snap.data['content'] as String,
      time: snap.data['unreadMessageCount'] as DateTime,
    );
  }
}
