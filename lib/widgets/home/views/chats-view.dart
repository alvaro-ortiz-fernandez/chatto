import 'package:chatto/models/message-model.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor
                ),
                margin: EdgeInsets.only(top: 5.0),
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message chat = chats[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            user: chat.sender
                          )
                        )
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: chat.unread
                            ? Color(0xFFEEF5FB)
                            : Colors.transparent
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                        user: chat.sender
                                      )
                                    )
                                  ),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: AssetImage(chat.sender.imageUrl),
                                  )
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      chat.sender.name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'GilroyBold'
                                      )
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Text(
                                        chat.text,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15.0
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  chat.time,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: 5.0),
                                chat.unread
                                  ? Container(
                                      width: 35.0,
                                      height: 35.0,
                                      padding: EdgeInsets.only(top: 3),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(35.0)
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '18',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontFamily: 'GilroyBold'
                                        )
                                      )
                                    )
                                  : Text('')
                              ],
                            )
                          ]
                        )
                      )
                    );
                  }
                )
              )
            )
          ]
        )
      )
    );
  }
}