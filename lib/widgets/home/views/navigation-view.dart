import 'package:chatto/models/navigation-model.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({ Key key, this.navigation }) : super(key: key);

  final Navigation navigation;

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor
        ),
        child: Column(
          children: <Widget>[
            widget.navigation.view
          ]
        )
      )
    );
  }
}