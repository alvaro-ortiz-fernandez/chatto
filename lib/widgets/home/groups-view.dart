import 'package:chatto/models/auth-model.dart';
import 'package:chatto/services/users-service.dart';
import 'package:flutter/material.dart';

class GroupsView extends StatefulWidget {

  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  UserData _currentUser;

  Future<void> loadData() async {
    UserData user = await UsersService.getUserLocal();
    setState(() => _currentUser = user);
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
                margin: EdgeInsets.only(top: 5.0)
              )
            )
          ]
        )
      )
    );
  }
}