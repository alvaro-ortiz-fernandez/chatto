import 'package:chatto/models/message-model.dart';
import 'package:chatto/models/user-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/widgets/chat/chat-message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({ this.user });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor
        ),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'GilroyBold',
                color: Colors.black
              )
            ),
            Text(
              'Hace 54 minutos',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700]
              )
            )
          ]
        ),
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  user: widget.user
                )
              )
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage(widget.user.imageUrl),
              )
            )
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 15.0),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = messages[index];
                  bool isMe = message.sender.id == currentUser.id;
                  return new ChatMessage(message: message, isMe: isMe);
                },
              )
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0.0, -3.0)
                )
              ]
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe un mensaje...'
                    ),
                  )
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25.0,
                    color: Colors.white,
                    onPressed: () {},
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}