import 'package:chatto/models/auth-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String receiver;
  final DateTime time;
  final String content;
  final bool unread;

  Message({
    this.sender,
    this.receiver,
    this.time,
    this.content,
    this.unread
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    Message message = Message(
      sender: doc['sender'] ?? '',
      receiver: doc['receiver'] ?? '',
      time: doc['time'] != null ? doc['time'].toDate() : null,
      content: doc['content'] ?? '',
      unread: doc['unread'] ?? false
    );
    return message;
  }
}

class MessageView extends Message {
  final UserData senderData;
  final UserData receiverData;

  MessageView(String sender, String receiver, DateTime time, String content, bool unread, this.senderData, this.receiverData)
    : super(sender: sender, receiver: receiver, time: time, content: content, unread: unread);
}