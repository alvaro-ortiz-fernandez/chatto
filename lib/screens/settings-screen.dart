import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/models/settings-model.dart';
import 'package:chatto/services/settings-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:chatto/widgets/settings/settings-view.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static final String id = 'settings_screen';

  static _SettingsScreenState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_SettingsScreenState>());
  }

  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin, Loadable {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static UserData _currentUser = UserData.emptyUser();
  List<SettingGroup> settings = List<SettingGroup>();

  MenuController menuController;
  bool loadError = false;

  @override
  Future<void> loadData() async {
    startLoading();
    setState(() => loadError = false);

    try {
      UserData user = await UsersService.getUserLocal();
      setState(() => _currentUser = user);

      List<SettingGroup> userSettings = await SettingsService.loadSettings(user.id);
      setState(() => settings = userSettings);

    } catch(e,  stackTrace) {
      setState(() => loadError = true);
      print('Error cargando los mensajes del usuario: ' + e.toString());
      print(stackTrace.toString());
    } finally {
      stopLoading();
    }
  }

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    loadData();
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
          loadError
            ? getLoadErrorBody()
            : NavigationView(navigation: Navigation(
                title: 'Ajustes',
                icon: Icons.settings,
                view: SettingsView(),
                parent: SettingsScreen()
              ))
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        scaffoldKey: _scaffoldKey,
        title: 'Ajustes',
        menuScreen: MenuScreen(currentUser: _currentUser),
        contentScreen: Layout(
          contentBuilder: (cc) => getSreenBody()
        )
      )
    );
  }

  Future<void> loadUserSettings() async {
    await SettingsService.loadSettings(_currentUser.id);
  }

  Future<void> updateSetting(UserSetting setting, bool newValue) async {
    startLoading();
    SettingsService
      .setSetting(setting.userId, setting.key, newValue)
        .whenComplete(() => stopLoading());
  }
}