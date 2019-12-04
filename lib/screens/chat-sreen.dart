import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/services/messages-service.dart';
import 'package:chatto/services/snackbar-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/chat/chat-message.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserData talkingUser;

  ChatScreen({ this.talkingUser });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with Loadable {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _scheduledMessageFormKey = GlobalKey<FormState>();
  ScrollController _scrollController = new ScrollController();
  String _content, _scheduled;

  UserData _currentUser;
  bool loadError = false;

  static List<MessageView> lastFoundMessages = List<MessageView>();
  List<StreamSubscription> streamSubscriptions = List<StreamSubscription>();
  List<MessageView> messages = List<MessageView>();

  Future<void> loadData() async {
    startLoading();
    setState(() {
      messages = lastFoundMessages;
    });

    UserData user = await UsersService.getUserLocal();
    setState(() => _currentUser = user);

    _getMessagesStream()
      .then((Stream<Iterable<MessageView>> messagesStream) {
        streamSubscriptions.add(messagesStream.listen((Iterable<MessageView> foundMessages) {
          if (mounted) {
            setState(() {
              List<MessageView> newMessages = foundMessages.toList();
              newMessages.sort((mess1, mess2) => mess2.time.isBefore(mess1.time) ? -1 : 1);
              messages = newMessages;
              lastFoundMessages = newMessages;
            });
            stopLoading();
          }
        }));
    });
  }

  Future<Stream<Iterable<MessageView>>> _getMessagesStream() async {
    return await MessagesService.getConversation(_currentUser.id, widget.talkingUser.id);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();

    for (final StreamSubscription streamSubscription in streamSubscriptions) {
      streamSubscription.cancel();
    }
  }

  @override
  String getLoadingTitle() {
    return 'Cargando';
  }

  @override
  Widget getWidgetBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor
            ),
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.only(top: 15.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final MessageView message = messages.elementAt(index);
                bool isMe = (_currentUser != null && message.senderData.id == _currentUser.id);
                return ChatMessage(message: message, isMe: isMe);
              }
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
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
          padding: EdgeInsets.only(
            top: 10,
            right: 20,
            bottom: 10,
            left: 10
          ),
          child:Form(
            key: _formKey,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.schedule),
                  iconSize: 28.0,
                  color: Colors.black45,
                  onPressed: () => mostrarDialogoNuevoMensajeProgramado(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextFormField(
                    onSaved: (input) => _content = input,
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
                    onPressed: () {
                      _formKey.currentState.save();
                      if (_content == null || _content.isEmpty) {
                        SnackbarService.showInfoSnackbar(
                          key: _scaffoldKey,
                          content: 'Por favor, introduzca un valor.'
                        );
                      } else {
                        MessagesService.newMessage(_currentUser.id, widget.talkingUser.id, _content)
                          .then((val) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );

                            MessageView message = MessageView(
                              _currentUser.id,
                              widget.talkingUser.id,
                              DateTime.now(),
                              _content,
                              true,
                              _currentUser,
                              widget.talkingUser
                            );
                            setState(() {
                              messages.add(message);
                              messages.sort((mess1, mess2) => mess2.time.isBefore(mess1.time) ? -1 : 1);
                              lastFoundMessages = messages;
                            });
                          })
                          .catchError((error) {
                            SnackbarService.showErrorSnackbar(
                              key: _scaffoldKey,
                              content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
                            );
                          })
                          .whenComplete(() => stopLoading());
                        _formKey.currentState.reset();
                      }
                    },
                  )
                )
              ]
            )
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              widget.talkingUser.name,
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
                  currentUser: _currentUser,
                  user: widget.talkingUser
                )
              )
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage(
                  widget.talkingUser.imageUrl != null && widget.talkingUser.imageUrl.isNotEmpty
                    ? widget.talkingUser.imageUrl
                    : UsersService.defaultAvatarPath
                ),
              )
            )
          )
        ],
      ),
      body: getSreenBody()
    );
  }

  void mostrarDialogoNuevoMensajeProgramado() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Programar mensaje',
            style: TextStyle(
              fontFamily: 'GilroyBold'
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Introduce el mensaje, fecha y hora a la que quieres que se envíe.'),
                SizedBox(height: 10),
                Form(
                  key: _scheduledMessageFormKey,
                  child: TextFormField(
                    onSaved: (input) => _scheduled = input,
                    decoration: InputDecoration(
                      hintText: 'Mensaje'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, introduzca un valor';
                      }
                      return null;
                    }
                  )
                )
              ]
            )
          ),
          actions: <Widget>[
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'PROGRAMAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                if (_scheduledMessageFormKey.currentState.validate()) {
                  startLoading();
                  Navigator.of(context).pop();

                  Future.delayed(Duration(seconds: 2), () => throw Exception())
                    .then((val) {
                      SnackbarService.showInfoSnackbar(
                        key: _scaffoldKey,
                        content: 'Mensaje programado correctamente.'
                      );
                    })
                    .catchError((error) {
                      SnackbarService.showErrorSnackbar(
                        key: _scaffoldKey,
                        content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
                      );
                    })
                    .whenComplete(() => stopLoading());
                }
              }
            )
          ]
        );
      }
    );
  }
}