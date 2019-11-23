import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/event-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/dialog-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatefulWidget {
  final UserData currentUser;

  RequestsView({ this.currentUser });

  @override
  RequestsViewState createState() => new RequestsViewState();
}

class RequestsViewState extends State<RequestsView> {

  StreamSubscription requestsChangedSubscription;
  List<UserData> requests = List<UserData>();

  @override
  void initState() {
    super.initState();
    setState(() {
      requests = UsersScreen.of(context).requests;
    });

    requestsChangedSubscription = eventBus
      .on<RequestsChangedEvent>()
      .listen((RequestsChangedEvent event) {
        setState(() => requests = event.currentRequests);
      });
  }

  @override
  void dispose() {
    super.dispose();

    if (requestsChangedSubscription != null)
      requestsChangedSubscription.cancel();
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
                  itemCount: requests.length,
                  itemBuilder: (BuildContext context, int index) {
                    final UserData user = requests[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            currentUser: widget.currentUser,
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
                                  backgroundImage: AssetImage(
                                    user.imageUrl != null && user.imageUrl.isNotEmpty
                                      ? user.imageUrl
                                      : UsersService.defaultAvatarPath
                                  ),
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
                                      icon: Icon(Icons.check),
                                      iconSize: 28.0,
                                      color: Theme.of(context).primaryColor,
                                      tooltip: 'Aceptar',
                                      onPressed: () {
                                        mostrarAlertaAceptacion(user.name)
                                          .then((decision) {
                                            if (decision == true)
                                              UsersScreen.of(context).aceptarPeticion(user);
                                          });
                                      }
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      iconSize: 28.0,
                                      color: Colors.red,
                                      tooltip: 'Rechazar',
                                      onPressed: () {
                                        mostrarAlertaDenegacion(user.name)
                                          .then((decision) {
                                            if (decision == true)
                                              UsersScreen.of(context).rechazarPeticion(user);
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

  Future<bool> mostrarAlertaAceptacion(String userName) async {
    return DialogService.showInfoDialog(
      context: context,
      title: 'Aceptar invitación',
      description: '¿Desea agregar a $userName?',
      action: 'ACEPTAR'
    );
  }

  Future<bool> mostrarAlertaDenegacion(String userName) async {
    return DialogService.showDangerDialog(
      context: context,
      title: 'Rechazar invitación',
      description: '¿Desea rechazar a $userName?',
      action: 'RECHAZAR'
    );
  }
}