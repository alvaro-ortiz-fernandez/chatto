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