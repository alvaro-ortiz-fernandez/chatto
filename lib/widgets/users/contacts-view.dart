import 'package:chatto/models/user-model.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:flutter/material.dart';


class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => new _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
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
                  itemCount: favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    final User user = favorites[index];
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
                                        'testAtestAtest@mail.com',
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
                                            user: user
                                          )
                                        )
                                      )
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.block),
                                      iconSize: 28.0,
                                      color: Colors.black54,
                                      tooltip: 'Bloquear',
                                      onPressed: () => mostrarAlertaBloqueo(user.name)
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      iconSize: 28.0,
                                      color: Colors.red,
                                      tooltip: 'Eliminar',
                                      onPressed: () => mostrarAlertaEliminacion(user.name)
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
    return mostrarAlerta(
      'Bloquear contacto',
      '¿Desea bloquear a $userName?',
      'BLOQUEAR'
    );
  }

  Future<bool> mostrarAlertaEliminacion(String userName) async {
    return mostrarAlerta(
      'Eliminar contacto',
      '¿Desea eliminar a $userName?',
      'ELIMINAR'
    );
  }

  // Método que muestra la alerta de bloquear usuario
  Future<bool> mostrarAlerta(String title, String description, String action) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'GilroyBold'
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description)
              ]
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                action,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return true;
              }
            )
          ]
        );
      }
    );
  }
}