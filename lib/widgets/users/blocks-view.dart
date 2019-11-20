import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/dialog-service.dart';
import 'package:flutter/material.dart';


class BlocksView extends StatefulWidget {
  @override
  BlocksViewState createState() => new BlocksViewState();
}

class BlocksViewState extends State<BlocksView> {

  List<UserData> blocks = List<UserData>();

  @override
  void initState() {
    super.initState();
    setState(() {
      blocks = UsersScreen.of(context).blocks;
    });
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
                  itemCount: blocks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final UserData user = blocks[index];
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
                                      icon: Icon(Icons.report_off),
                                      iconSize: 28.0,
                                      color: Colors.black54,
                                      tooltip: 'Desbloquear',
                                      onPressed: () => mostrarAlertaDesbloqueo(user.name)
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

  Future<bool> mostrarAlertaDesbloqueo(String userName) async {
    return DialogService.showDefaultDialog(
      context: context,
      title: 'Desbloquear usuario',
      description: '¿Desea desbloquear a $userName?',
      action: 'Desbloquear'
    );
  }
}