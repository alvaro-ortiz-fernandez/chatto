import 'package:chatto/models/user-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:flutter/material.dart';


class RequestsView extends StatefulWidget {
  @override
  _RequestsViewState createState() => new _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
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
                                      icon: Icon(Icons.check),
                                      iconSize: 28.0,
                                      color: Theme.of(context).primaryColor,
                                      tooltip: 'Aceptar',
                                      onPressed: () {
                                        SnackBar snackBar = SnackBar(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          elevation: 10,
                                          duration: Duration(seconds: 3),
                                          content: Text('Petición de ${user.name} aceptada.'),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(snackBar);
                                      }
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      iconSize: 28.0,
                                      color: Colors.red,
                                      tooltip: 'Rechazar',
                                      onPressed: () {
                                        SnackBar snackBar = SnackBar(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          elevation: 10,
                                          duration: Duration(seconds: 3),
                                          content: Text('Petición de ${user.name} rechazada.'),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(snackBar);
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
}