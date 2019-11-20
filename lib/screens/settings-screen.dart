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

  MenuController menuController;
  bool loadError = false;

  _loadUser() {
    startLoading();
    setState(() => loadError = false);

    UsersService.getUserLocal()
      .then((user) => setState(() => _currentUser = user))
      .catchError((error) => setState(() => loadError = true))
      .whenComplete(() => stopLoading());
  }

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    _loadUser();
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
          loading
            ? Container()
            : loadError
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

  Widget getLoadErrorBody() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/error/error-exclamation.png'),
              height: 150,
              width: 150
            ),
            SizedBox(height: 30),
            Text(
              'Se ha producido un error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'GilroyBold',
              )
            ),
            SizedBox(height: 15),
            Text(
              'Se produjo un error al cargar la información, por favor, pulse el botón para volver a intentarlo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16
              )
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () => _loadUser(),
              padding: EdgeInsets.only(
                top: 10,
                right: 18,
                bottom: 10,
                left: 12
              ),
              color: Theme.of(context).primaryColor,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Reintentar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'GilroyBold'
                    )
                  )
                ]
              ),
            )
          ]
        )
      )
    );
  }

  Future<void> loadSharedPreferences() async {
    await SettingsService.loadSettings();
  }

  Future<void> updateSetting(Setting setting, bool newValue) async {
    startLoading();
    try {
      await SettingsService.setSetting(setting, newValue);
    } finally {
      stopLoading();
    }
  }
}