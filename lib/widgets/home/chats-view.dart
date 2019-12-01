import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/services/messages-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/widgets/ui/time-utils.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {

  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  static Iterable<MessageView> lastFoundMessages = Iterable.empty();
  Iterable<MessageView> messages = Iterable.empty();
  UserData _currentUser;

  Future<void> loadData() async {
    setState(() {
      print('messages.length (1): ' + messages.length.toString());
      messages = lastFoundMessages;
      print('messages.length (2): ' + messages.length.toString());
    });

    UserData user = await UsersService.getUserLocal();
    setState(() => _currentUser = user);

    _getMessagesStream()
      .then((Stream<Iterable<MessageView>> messagesStream) {
        print('messagesStream');

        messagesStream.listen((Iterable<MessageView> foundMessages) {
          print('########### foundMessages 2: ' + foundMessages.length.toString());
          setState(() {
            messages = foundMessages;
            lastFoundMessages = foundMessages;
          });
        });
      });
  }

  Future<Stream<Iterable<MessageView>>> _getMessagesStream() async {
    return await MessagesService.getChats();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

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
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final MessageView message = messages.elementAt(index);
                    return GestureDetector(
                      onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                              ChatScreen(
                                talkingUser: message.senderData
                              )
                          )
                        ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: message.unread
                            ? Color(0xFFEEF5FB)
                            : Colors.transparent
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () =>
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                          ProfileScreen(
                                            currentUser: _currentUser,
                                            user: message.senderData
                                          )
                                      )
                                    ),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: AssetImage(
                                      message.senderData.imageUrl !=
                                        null &&
                                        message.senderData.imageUrl
                                          .isNotEmpty
                                        ? message.senderData.imageUrl
                                        : UsersService.defaultAvatarPath
                                    ),
                                  )
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                  children: <Widget>[
                                    Text(
                                      message.senderData.name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'GilroyBold'
                                      )
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.45,
                                      child: Text(
                                        message.content,
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  TimeUtils.formatDate(message.time),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: 5.0),
                                message.unread
                                  ? Container(
                                      width: 35.0,
                                      height: 35.0,
                                      padding: EdgeInsets.only(top: 3),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          35.0)
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