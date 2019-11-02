import 'package:chatto/widgets/home/views/chats-view.dart';
import 'package:chatto/widgets/home/views/groups-view.dart';
import 'package:flutter/material.dart';

class Navigation {

  final String title;
  final IconData icon;
  final Widget view;

  Navigation({
    this.title,
    this.icon,
    this.view
  });
}

final List<Navigation> navigations = <Navigation>[
  Navigation(title: 'Chats', icon: Icons.chat_bubble, view: ChatsView()),
  Navigation(title: 'Grupos', icon: Icons.supervisor_account, view: GroupsView())
];