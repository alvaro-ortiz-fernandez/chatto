import 'package:chatto/models/auth-model.dart';
import 'package:chatto/widgets/profile/profile-stadistics.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final UserData user;

  ProfileScreen({ this.user });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: new BorderRadius.vertical(
                        bottom: new Radius.elliptical(
                          MediaQuery.of(context).size.width, 150.0
                        )
                      )
                    )
                  ),
                  Container(
                    constraints: BoxConstraints.loose(Size.fromHeight(80)),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      overflow: Overflow.visible,
                      children: [
                        Positioned(
                          top: -80.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                color: Theme.of(context).accentColor,
                                width: 5
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: CircleAvatar(
                              radius: 80.0,
                              backgroundImage: AssetImage(olivia.imageUrl)
                            )
                          )
                        )
                      ]
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          olivia.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'GilroyBold',
                            color: Colors.black
                          )
                        ),
                        Text(
                          'olivia@mail.com',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700]
                          )
                        )
                      ]
                    )
                  ),
                  Row(
                    children: <Widget>[
                      ProfileStadistics(),
                    ]
                  ),
                  Container(
                    child: Text(
                      'Última conexión: Hace 54 minutos',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700]
                      )
                    )
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 25,
                                  spreadRadius: -5,
                                  offset: Offset(0.0, 15.0),
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              child: MaterialButton(
                                onPressed: () {},
                                padding: EdgeInsets.only(
                                  top: 18,
                                  right: 35,
                                  bottom: 18,
                                  left: 25
                                ),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Agregar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'GilroyBold'
                                      )
                                    )
                                  ]
                                ),
                              )
                            )
                          ),
                          SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 25,
                                  spreadRadius: -5,
                                  offset: Offset(0.0, 15.0),
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              child: MaterialButton(
                                onPressed: () {},
                                padding: EdgeInsets.only(
                                  top: 18,
                                  right: 35,
                                  bottom: 18,
                                  left: 25
                                ),
                                color: Colors.redAccent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.block,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Bloquear',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'GilroyBold'
                                      )
                                    )
                                  ]
                                ),
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}