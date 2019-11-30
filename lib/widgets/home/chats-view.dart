import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/services/messages-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {

  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  UserData _currentUser;

  Future<void> loadData() async {
    UserData user = await UsersService.getUserLocal();
    setState(() => _currentUser = user);
  }

  Future<Stream<List<MessageView>>> _getMessagesStream() async {
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
                child: FutureBuilder<Stream<List<MessageView>>>(
                  future: _getMessagesStream(),
                  builder: (BuildContext context, AsyncSnapshot<Stream<List<MessageView>>> snapshot) {
                    print('ChatsView(1) - snapshot.hasData: ' + snapshot.hasData.toString());
                    if (!snapshot.hasData)
                      return Container();

                    print('ChatsView(2)');
                    return StreamBuilder(
                      stream: snapshot.data,
                      builder: (BuildContext context, AsyncSnapshot<List<MessageView>> snapshot) {
                        print('ChatsView(3) - snapshot.hasData: ' + snapshot.hasData.toString());
                        if (!snapshot.hasData)
                          return Container();

                        print('ChatsView(4)');
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final MessageView message = snapshot.data[index];
                            print('ChatsView(5)');
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
                                      children: <Widget>[
                                        Text(
                                          message.time.toString(),
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
                                            color: Theme
                                              .of(context)
                                              .primaryColor,
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
                        );
                      }
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