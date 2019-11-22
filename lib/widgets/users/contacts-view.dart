import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/event-model.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/dialog-service.dart';
import 'package:flutter/material.dart';

class ContactsView extends StatefulWidget {
  final UserData currentUser;

  ContactsView({ this.currentUser });

  @override
  ContactsViewState createState() => new ContactsViewState();
}

class ContactsViewState extends State<ContactsView> {

  StreamSubscription contactsChangedSubscription;
  List<UserData> contacts = List<UserData>();

  @override
  void initState() {
    super.initState();
    setState(() {
      contacts = UsersScreen.of(context).contacts;
    });

    contactsChangedSubscription = eventBus
      .on<ContactsChangedEvent>()
      .listen((ContactsChangedEvent event) {
        setState(() => contacts = event.currentContacts);
      });
  }

  @override
  void dispose() {
    super.dispose();

    if (contactsChangedSubscription != null)
      contactsChangedSubscription.cancel();
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
                  itemCount: contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final UserData user = contacts[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            user: user
                          )
                        )
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage(user.imageUrl),
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'GilroyBold'
                                      )
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.30,
                                      child: Text(
                                        user.email,
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
                                ButtonBar(
                                  buttonPadding: EdgeInsets.all(0),
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      iconSize: 28.0,
                                      color: Theme.of(context).primaryColor,
                                      tooltip: 'Enviar mensaje',
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            currentUser: widget.currentUser,
                                            talkingUser: user,
                                          )
                                        )
                                      )
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.block),
                                      iconSize: 28.0,
                                      color: Colors.black54,
                                      tooltip: 'Bloquear',
                                      onPressed: () {
                                        mostrarAlertaBloqueo(user.name)
                                          .then((decision) {
                                            if (decision == true)
                                              UsersScreen.of(context).bloquearContacto(user);
                                        });
                                      }
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      iconSize: 28.0,
                                      color: Colors.red,
                                      tooltip: 'Eliminar',
                                      onPressed: () {
                                        mostrarAlertaEliminacion(user.name)
                                          .then((decision) {
                                            if (decision == true)
                                              UsersScreen.of(context).eliminarContacto(user);
                                          });
                                      }
                                    )
                                  ],
                                )
                              ]
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

  Future<bool> mostrarAlertaBloqueo(String userName) async {
    return DialogService.showDefaultDialog(
      context: context,
      title: 'Bloquear contacto',
      description: '¿Desea bloquear a $userName?',
      action: 'BLOQUEAR'
    );
  }

  Future<bool> mostrarAlertaEliminacion(String userName) async {
    return DialogService.showDangerDialog(
      context: context,
      title: 'Eliminar contacto',
      description: '¿Desea eliminar a $userName?',
      action: 'ELIMINAR'
    );
  }
}