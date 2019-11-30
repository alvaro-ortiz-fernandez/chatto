import 'package:chatto/models/message-model.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final MessageView message;
  final bool isMe;

  ChatMessage({ this.message, this.isMe });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isMe
        ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
        : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe
          ? Theme.of(context).primaryColor
          : Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time.toString(),
            style: TextStyle(
              color: isMe
                ? Colors.white
                : Colors.grey[700],
              fontSize: 16.0,
              fontFamily: 'GilroyBold'
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.content,
            style: TextStyle(
              color: isMe
                ? Colors.white
                : Colors.black,
              fontSize: 16
            ),
          )
        ],
      )
    );
  }
}