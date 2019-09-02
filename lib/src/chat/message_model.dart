class Message {
  final String content;
  final DateTime timeStamp;
  final String from;
  final String to;

  Message({
    this.content,
    this.timeStamp,
    this.from,
    this.to,
  });

  dynamic toJSON() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'time': timeStamp,
    };
  }
}
