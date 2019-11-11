import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/models/user-model.dart';
import 'package:chatto/widgets/menu/circular-image.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: true).toggle();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 62,
          left: 32,
          bottom: 8,
          right: MediaQuery.of(context).size.width / 2.9),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircularImage(
                    AssetImage(currentUser.imageUrl),
                  ),
                ),
                Text(
                  currentUser.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Spacer(),
            buildMenuList(context, homeNavigations),
            Spacer(),
            buildMenuList(context, usersNavigations),
            Spacer(),
            buildMenuList(context, settingsNavigations)
          ]
        )
      )
    );
  }

  buildMenuList(BuildContext context, List<Navigation> navigations) {
    return Column(
      children: navigations.map((navigation) {
        return ListTile(
          leading: Icon(
            navigation.icon,
            color: Colors.white,
            size: 20,
          ),
          title: Text(
            navigation.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
          onTap: () => navigation.onTap != null
            ? navigation.onTap(context)
            : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => navigation.parent
              )
            )
        );
      }).toList(),
    );
  }
}