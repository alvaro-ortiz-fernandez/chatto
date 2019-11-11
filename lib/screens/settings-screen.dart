import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/models/settings-model.dart';
import 'package:chatto/services/shared-preferences-service.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {

  static _SettingsScreenState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_SettingsScreenState>());
  }

  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin, Loadable {

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
  String getLoadingTitle() {
    return 'Actualizando preferencias';
  }

  @override
  Widget getWidgetBody() {
    return SafeArea(
      top: false,
      child: IndexedStack(
        index: 0,
        children: [
          NavigationView(navigation: settingsNavigations[0])
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        title: 'Ajustes',
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => getSreenBody()
        )
      )
    );
  }

  Future<void> loadSharedPreferences() async {
    await SharedPreferencesService.loadSharedPreferences();
  }

  Future<void> updateSetting(Setting setting, bool newValue) async {
    startLoading();
    try {
      await SharedPreferencesService.setSharedPreference(setting, newValue);
    } finally {
      stopLoading();
    }
  }
}