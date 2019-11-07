import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {

  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        title: 'Ajustes',
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => SafeArea(
            top: false,
            child: IndexedStack(
              index: 0,
              children: [
                NavigationView(navigation: settingsNavigations[0])
              ]
            )
          )
        )
      )
    );
  }
}