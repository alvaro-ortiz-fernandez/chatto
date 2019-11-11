import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/settings-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/widgets/home/chats-view.dart';
import 'package:chatto/widgets/home/groups-view.dart';
import 'package:chatto/widgets/settings/settings-view.dart';
import 'package:chatto/widgets/users/blocks-view.dart';
import 'package:chatto/widgets/users/contacts-view.dart';
import 'package:chatto/widgets/users/requests-view.dart';
import 'package:flutter/material.dart';

class Navigation {

  final String title;
  final IconData icon;
  final Widget view;
  final Widget parent;
  final Function onTap;

  Navigation({
    this.title,
    this.icon,
    this.view,
    this.parent,
    this.onTap
  });
}

final List<Navigation> homeNavigations = <Navigation>[
  Navigation(title: 'Chats', icon: Icons.chat_bubble, view: ChatsView(), parent: HomeScreen(currentIndex: 0)),
  Navigation(title: 'Grupos', icon: Icons.supervisor_account, view: GroupsView(), parent: HomeScreen(currentIndex: 1))
];

final List<Navigation> usersNavigations = <Navigation>[
  Navigation(title: 'Contactos', icon: Icons.supervisor_account, view: ContactsView(), parent: UsersScreen(currentIndex: 0)),
  Navigation(title: 'Peticiones', icon: Icons.account_circle, view: RequestsView(), parent: UsersScreen(currentIndex: 1)),
  Navigation(title: 'Bloqueados', icon: Icons.block, view: BlocksView(), parent: UsersScreen(currentIndex: 2))
];

final List<Navigation> settingsNavigations = <Navigation>[
  Navigation(title: 'Ajustes', icon: Icons.settings, view: SettingsView(), parent: SettingsScreen()),
  Navigation(title: 'Salir', icon: Icons.power_settings_new, onTap: (context) => AuthService.logout(context))
];