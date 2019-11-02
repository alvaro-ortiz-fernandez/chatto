import 'package:chatto/models/user-model.dart';
import 'package:chatto/widgets/home/menu/circular-image.dart';
import 'package:chatto/widgets/home/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  final List<MenuItem> mainOptions = [
    MenuItem(Icons.search, 'Search'),
    MenuItem(Icons.shopping_basket, 'Basket')
  ];

  final List<MenuItem> secondaryOptions = [
    MenuItem(Icons.settings, 'Ajustes'),
    MenuItem(Icons.power_settings_new, 'Salir')
  ];

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
            buildMenuList(mainOptions),
            Spacer(),
            buildMenuList(secondaryOptions)
          ]
        )
      )
    );
  }

  buildMenuList(List<MenuItem> menuItems) {
    return Column(
      children: menuItems.map((item) {
        return ListTile(
          leading: Icon(
            item.icon,
            color: Colors.white,
            size: 20,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}