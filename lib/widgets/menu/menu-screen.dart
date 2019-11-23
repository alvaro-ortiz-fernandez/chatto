import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/settings-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/menu/circular-image.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {

  final UserData currentUser;

  final List<Navigation> homeNavigations = <Navigation>[
    Navigation(title: 'Chats', icon: Icons.chat_bubble, parent: HomeScreen(currentIndex: 0)),
    Navigation(title: 'Grupos', icon: Icons.supervisor_account, parent: HomeScreen(currentIndex: 1))
  ];
  final List<Navigation> usersNavigations = <Navigation>[
    Navigation(title: 'Contactos', icon: Icons.supervisor_account, parent: UsersScreen(currentIndex: 0)),
    Navigation(title: 'Peticiones', icon: Icons.account_circle, parent: UsersScreen(currentIndex: 1)),
    Navigation(title: 'Bloqueados', icon: Icons.block, parent: UsersScreen(currentIndex: 2))
  ];
  final List<Navigation> settingsNavigations = <Navigation>[
    Navigation(title: 'Ajustes', icon: Icons.settings, parent: SettingsScreen()),
    Navigation(title: 'Salir', icon: Icons.power_settings_new, onTap: (context) => AuthService.logout(context))
  ];

  MenuScreen({ this.currentUser });

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
                    AssetImage(
                      currentUser.imageUrl != null && currentUser.imageUrl.isNotEmpty
                        ? currentUser.imageUrl
                        : UsersService.defaultAvatarPath
                    ),
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